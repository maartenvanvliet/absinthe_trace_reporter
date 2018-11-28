defmodule AbsintheTraceReporter do
  @moduledoc """
  Documentation for AbsintheTracingReporter.

  ```
  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ApqExample.Worker.start_link(arg)
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: ApqExample.Router,
        options: [port: 4001]
      ),
      supervisor(AbsintheTraceReporter, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApqExample.Supervisor]
    Supervisor.start_link(children, opts)

  end
  ```

  """

  use GenServer
  @max_traces 10

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    schedule_report()

    {:ok, state}
  end

  def handle_cast({:add_trace, trace}, state) do
    state = [trace] ++ state
    send_report(state, @max_traces)
  end

  def handle_info(:scheduled_report, state) do
    schedule_report()
    send_report(state, 1)
  end

  def handle_call(:traces, _from, state), do: {:reply, state, state}

  def add_trace(trace),
    do: GenServer.cast(__MODULE__, {:add_trace, trace})

  def traces(), do: GenServer.call(__MODULE__, :traces)

  defp schedule_report do
    Process.send_after(
      self(),
      :scheduled_report,
      5 * 1000
    )
  end

  defp send_report(state, max_traces) do
    case length(state) >= max_traces do
      true ->
        AbsintheTraceReporter.Reporter.ApolloEngine.report(state)
        {:noreply, []}

      false ->
        {:noreply, state}
    end
  end
end
