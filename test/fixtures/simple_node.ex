defmodule AbsintheTraceReporter.Fixtures.SimpleNode do
  def resolvers do
    [
      %{
        duration: 1_514_000,
        fieldName: "number",
        meta: nil,
        parentType: "RootQueryType",
        path: ["number"],
        returnType: "Int",
        startOffset: 55_903_000
      }
    ]
  end

  def trace_result do
    %Mdg.Engine.Proto.Trace.Node{
      cache_policy: nil,
      child: [
        %Mdg.Engine.Proto.Trace.Node{
          cache_policy: nil,
          child: [],
          end_time: 55_903_000 + 1_514_000,
          error: [],
          id: {:field_name, "number"},
          parent_type: "RootQueryType",
          start_time: 55_903_000,
          type: "Int"
        }
      ],
      end_time: 0,
      error: [],
      id: {:field_name, "RootQueryType"},
      parent_type: "",
      start_time: 0,
      type: ""
    }
  end
end
