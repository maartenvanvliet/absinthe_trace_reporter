defmodule AbsintheTraceReporter.Phases.TraceCollector do
  use Absinthe.Phase
  alias AbsintheTraceReporter.Trace
  def run(bp, _options \\ [])

  def run(bp, _options) do
    case bp do
      %{execution: %{acc: %{apollo_tracing: trace}}, operations: operations} ->
        signature = AbsintheTraceReporter.Signature.build(operations)

        info = from_context(bp)

        trace = Trace.build(signature, trace, info)
        AbsintheTraceReporter.add_trace(trace)
        {:ok, bp}

      bp ->
        {:ok, bp}
    end
  end

  defp from_context(%{execution: %{context: %{trace_info: info}}}) do
    info
  end

  defp from_context(_) do
    %{}
  end
end
