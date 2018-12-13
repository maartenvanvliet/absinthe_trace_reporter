defmodule AbsintheTraceReporter.Reporter.ApolloEngine do
  @engine_endpoint "https://engine-report.apollodata.com/api/ingress/traces"

  require Logger
  alias AbsintheTraceReporter.TraceProvider.Engine

  use Tesla

  plug(Tesla.Middleware.Headers, [
    {"user-agent", "apollo-engine-reporting"}
  ])

  plug(Tesla.Middleware.Compression, format: "gzip")

  def report(config, tracing) when is_list(tracing) do
    engine_endpoint = Keyword.get(config, :engine_endpoint, @engine_endpoint)
    api_key = Keyword.fetch!(config, :api_key)

    tracing = Engine.build_trace_report(tracing)

    post(engine_endpoint, tracing, headers: [{"x-api-key", api_key}])
    |> case do
      {:ok, %{status: status, body: body}} when status != 200 ->
        Logger.warn(
          "Could not report traces to Apollo Engine: status: #{status} #{inspect(body)}"
        )

      _ ->
        Logger.info("Sucessfully reported traces to Apollo Engine")
    end
  end
end
