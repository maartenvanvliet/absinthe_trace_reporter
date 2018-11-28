defmodule AbsintheTraceReporter.Pipeline do
  def default(config, pipeline_opts) do
    config.schema_mod
    |> Absinthe.Pipeline.for_document(pipeline_opts)
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Blueprint,
      ApolloTracer.Phase.CreateTracing
    )
    |> Absinthe.Pipeline.insert_before(
      Absinthe.Phase.Document.Result,
      ApolloTracer.Phase.AccumulateResult
    )
    |> Absinthe.Pipeline.insert_after(
      Absinthe.Phase.Document.Result,
      AbsintheTraceReporter.Phases.TraceCollector
    )
  end
end
