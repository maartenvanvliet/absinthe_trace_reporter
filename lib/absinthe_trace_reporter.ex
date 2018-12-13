defmodule AbsintheTraceReporter do
  @moduledoc """
  Documentation for AbsintheTracingReporter.

  Options for the reporter
  `api_key` Apollo Engine api key (required)
  `engine_endpoint` Endpoint to report traces to, defaults to Apollo Engine
  `max_traces` Maximum number of traces before a report is send to Apollo Engine (default: 10)
  `interval` Max number of seconds to wait before sending report to engine (default: 5 sec)

  `max_traces` and `interval` trigger when to send report to Engine, whichever one is hit first

  ```
  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Example.Worker.start_link(arg)
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: Example.Router,
        options: [port: 4001]
      ),
      supervisor(AbsintheTraceReporter, [[api_key: "service:name..key..."]])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)

  end
  ```

  """

  use GenServer
  @max_traces 10
  @interval 5 * 1000

  def start_link(config \\ []) do
    GenServer.start_link(__MODULE__, {config, []}, name: __MODULE__)
  end

  def init({config, traces}) do
    schedule_report(config)

    {:ok, {config, traces}}
  end

  def handle_cast({:add_trace, trace}, {config, traces}) do
    max_traces = Keyword.get(config, :max_traces, @max_traces)

    traces = [trace] ++ traces
    send_report({config, traces}, max_traces)
  end

  def handle_info(:scheduled_report, {config, traces}) do
    schedule_report(config)
    send_report({config, traces}, 1)
  end

  def handle_call(:traces, _from, {config, traces}) do
    {:reply, traces, {config, traces}}
  end

  def add_trace(trace),
    do: GenServer.cast(__MODULE__, {:add_trace, trace})

  def traces(), do: GenServer.call(__MODULE__, :traces)

  defp schedule_report(config) do
    interval = Keyword.get(config, :interval, @interval)

    Process.send_after(
      self(),
      :scheduled_report,
      interval
    )
  end

  defp send_report({config, traces}, max_traces) do
    case length(traces) >= max_traces do
      true ->
        AbsintheTraceReporter.Reporter.ApolloEngine.report(config, traces)
        {:noreply, {config, []}}

      false ->
        {:noreply, {config, traces}}
    end
  end
end
