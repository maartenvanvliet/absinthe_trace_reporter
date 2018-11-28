defmodule AbsintheTraceReporter.TraceProvider.Engine do
  @behaviour AbsintheTraceReporter.TraceReportProvider

  def build_trace_report(tracing) when is_list(tracing) do
    %Mdg.Engine.Proto.FullTracesReport{
      header: %Mdg.Engine.Proto.ReportHeader{
        agent_version: "apollo-engine-reporting@0.0.2",
        hostname: "",
        runtime_version: runtime_version(),
        service: "",
        service_version: "",
        uname: ""
      },
      traces_per_query: build_traces_per_query(tracing)
    }
    |> Mdg.Engine.Proto.FullTracesReport.encode()
  end

  defp build_traces_per_query(tracing) when is_list(tracing) do
    tracing
    |> Enum.map(fn trace ->
      {trace.signature,
       Mdg.Engine.Proto.Trace.new(
         root: from_trace(trace),
         origin_reported_start_time: build_timestamp(trace.start_time),
         start_time: build_timestamp(trace.start_time),
         end_time: build_timestamp(trace.end_time),
         origin_reported_end_time: build_timestamp(trace.end_time)
       )}
    end)
    |> Enum.group_by(fn {signature, _trace} -> signature end, fn {_signature, trace} -> trace end)
    |> Enum.map(fn {sig, traces} ->
      {sig, %Mdg.Engine.Proto.Traces{trace: traces}}
    end)
    |> Enum.into(%{})
  end

  defp build_timestamp(time) do
    {:ok, time, _offset} = DateTime.from_iso8601(time)
    ns = nanoseconds(time)

    Google.Protobuf.Timestamp.new(
      seconds: DateTime.to_unix(time),
      nanos: ns
    )
  end

  defp nanoseconds(datetime) do
    case datetime.microsecond do
      {_, 0} -> 0
      {end_time_ms, _} -> end_time_ms * 1000
    end
  end

  def runtime_version do
    "Elixir #{System.version()}"
  end

  def from_trace(trace) do
    trace.tracing
    |> from_blueprint_execution
    |> build_trace_tree()
  end

  defp root_node do
    %{
      duration: 0,
      fieldName: "RootQueryType",
      meta: nil,
      parentType: "",
      path: [],
      returnType: "",
      startOffset: 0,
      child: []
    }
  end

  defp from_blueprint_execution(%{execution: %{resolvers: resolvers}}) do
    resolvers
  end

  defp from_blueprint_execution(_) do
    []
  end

  def build_trace_tree(resolvers) when is_list(resolvers) do
    # We prepend a root node
    nodes_list = [root_node() | resolvers]
    nodes_depth_map = nodes_by_depth_map(nodes_list, %{})

    initial_depth_level = 0

    initial_list = Map.get(nodes_depth_map, initial_depth_level)
    initial_nodes_depth_map = Map.delete(nodes_depth_map, initial_depth_level)

    Enum.reduce(
      initial_list,
      nil,
      fn node, _list ->
        extract(node, initial_nodes_depth_map, initial_depth_level)
      end
    )
  end

  def build_trace_tree(_) do
    []
  end

  def tree([node | tail]) do
    children =
      tail
      |> Enum.filter(fn child ->
        case child.path |> Enum.reverse() do
          [_, i | path] when is_integer(i) -> Enum.reverse(node.path) == path
          [_ | path] -> Enum.reverse(node.path) == path
          _ -> false
        end
      end)
      |> Enum.map(fn child ->
        case child.path |> Enum.reverse() do
          [_, i | _path] when is_integer(i) -> {:index, i, child}
          _ -> {:child, child}
        end
      end)
      |> IO.inspect(label: "childnodes")

    child_nodes =
      children
      |> Enum.map(fn
        {:index, i, child} ->
          build_node_index(
            i,
            children
            |> Enum.map(fn {:index, i, c} ->
              build_node(c, tail)
            end)
          )

        {:child, child} ->
          case tail do
            [_ | tail] ->
              tail
              |> Enum.filter(fn child ->
                case child.path |> Enum.reverse() do
                  [_ | path] -> Enum.reverse(node.path) == path
                  _ -> false
                end
              end)
              |> Enum.map(fn n ->
                build_node(child, tree(tail))
              end)

            [child2] ->
              build_node(child, child2)

            [] ->
              build_node(child, [])
          end
      end)

    build_node(node, child_nodes)
  end

  def tree([]) do
    []
  end

  def extract(node, nodes_depth_map, 0) do
    next_depth_level = 1

    case {Map.get(nodes_depth_map, next_depth_level, []),
          Map.get(nodes_depth_map, next_depth_level + 1, [])} do
      {children, []} ->
        children =
          Enum.map(children, fn child ->
            build_node(child, extract(child, nodes_depth_map, next_depth_level))
          end)

        build_node(node, children)

      {children, _} ->
        children =
          Enum.map(children, fn child ->
            build_node(child, extract(child, nodes_depth_map, next_depth_level))
          end)

        build_node(node, children)
    end
  end

  def extract(f, nodes_depth_map, depth_level) do
    next_depth_level = depth_level + 1

    nodes = Map.get(nodes_depth_map, next_depth_level, [])
    maybe_index_nodes = Map.get(nodes_depth_map, next_depth_level + 1, [])

    case {nodes, maybe_index_nodes} do
      {[], []} ->
        []

      {[], indexed_nodes} ->
        indexed_nodes(f, indexed_nodes, nodes_depth_map, next_depth_level)

      {[singular_node], []} ->
        build_node(singular_node, extract(singular_node, nodes_depth_map, next_depth_level))

      {[singular_node], child} ->
        build_node(singular_node, extract(child, nodes_depth_map, next_depth_level))

      {multiple_nodes, _child} ->
        Enum.map(multiple_nodes, fn child ->
          build_node(child, extract(child, nodes_depth_map, next_depth_level))
        end)
    end
  end

  # When the nodes at level n don't exist but they do at n + 1 we
  # deal with a list of items
  defp indexed_nodes(root, indexed_nodes, nodes_depth_map, next_depth_level) do
    indexed_nodes
    |> Enum.filter(fn node ->
      case node.path |> Enum.reverse() do
        [_, i | tail] when is_integer(i) -> Enum.reverse(root.path) == tail
        _ -> false
      end
    end)
    |> Enum.group_by(fn node ->
      node.path |> Enum.reverse() |> Enum.filter(fn i -> is_integer(i) end) |> Enum.at(0)
    end)
    |> Enum.map(fn {i, nodes} ->
      nodes =
        Enum.map(nodes, fn child ->
          build_node(child, extract(child, nodes_depth_map, next_depth_level + 1))
        end)

      build_node_index(i, nodes)
    end)
  end

  defp build_node(field, children) when is_list(children) do
    Mdg.Engine.Proto.Trace.Node.new(
      cache_policy: nil,
      child: children,
      end_time: field.startOffset + field.duration,
      error: [],
      id: {:field_name, field.fieldName},
      parent_type: field.parentType,
      start_time: field.startOffset,
      type: field.returnType
    )
  end

  defp build_node(field, children) do
    build_node(field, [children])
  end

  def build_node_index(i, children \\ []) do
    Mdg.Engine.Proto.Trace.Node.new(
      cache_policy: nil,
      child: children,
      end_time: 0,
      error: [],
      id: {:index, i},
      parent_type: "",
      start_time: 0,
      type: ""
    )
  end

  defp nodes_by_depth_map([], processed_map), do: processed_map

  defp nodes_by_depth_map([node | tail], before_node_processed_map) do
    path = Map.get(node, :path)
    node_depth = depth(node, path)

    node_at_depth = Map.get(before_node_processed_map, node_depth, []) ++ [node]
    after_node_processed_map = Map.put(before_node_processed_map, node_depth, node_at_depth)

    case tail do
      tail when is_list(tail) -> nodes_by_depth_map(tail, after_node_processed_map)
      tail -> nodes_by_depth_map([tail], after_node_processed_map)
    end
  end

  def depth(_, path) when is_list(path), do: length(path)
end
