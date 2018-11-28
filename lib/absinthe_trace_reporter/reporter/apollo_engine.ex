defmodule AbsintheTraceReporter.Reporter.ApolloEngine do
  @engine_endpoint "https://engine-report.apollodata.com/api/ingress/traces"
  @api_key "api_key"

  require Logger
  alias AbsintheTraceReporter.TraceProvider.Engine

  use Tesla

  plug(Tesla.Middleware.Headers, [
    {"user-agent", "apollo-engine-reporting"},
    {"x-api-key", @api_key}
  ])

  plug(Tesla.Middleware.Compression, format: "gzip")

  def report(tracing) when is_list(tracing) do
    tracing = Engine.build_trace_report(tracing)

    post(@engine_endpoint, tracing)
    |> case do
      {:ok, %{status: status, body: body}} when status != 200 ->
        Logger.warn(
          "Could not report traces to Apollo Engine: status: #{status} #{inspect(body)}"
        )

      res ->
        Logger.info("Sucessfully reported traces to Apollo Engine")
    end
  end
end
