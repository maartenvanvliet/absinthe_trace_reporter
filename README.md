# WIP do not use in production

[![Build Status](https://travis-ci.com/maartenvanvliet/absinthe_trace_reporter.svg?branch=master)](https://travis-ci.com/maartenvanvliet/absinthe_trace_reporter) [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# AbsintheTracingReporter

Apollo Engine reporter that sends Absinthe traces built by https://github.com/sikanhe/apollo-tracing-elixir to Apollo engine directly without having to use a the (deprecated) engine proxy. 

# TODO
 - [ ] Add failing tests for tracing information by (https://github.com/sikanhe/apollo-tracing-elixir) to being converted to correct Engine trace reports
 - [ ] Fix converting tracing information to correct Engine trace reports
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `absinthe_tracing_reporter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:absinthe_tracing_reporter, "~> 0.1.0"}
  ]
end
```

For installation you need two things, first a process that runs and collects the traces. After an x number of traces or x seconds it sends the report to Apollo Engine.
Secondly, the Absinthe pipeline needs to be adjusted. We add the apollo tracing information during query execution and in the last phase we collect this information to send it to the tracing reporter.

Add the reporter to the supervisor tre
```
  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: ExampleApp.Worker.start_link(arg)
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: ExampleApp.Router,
        options: [port: 4001]
      ),

      # Absinthe reporter
      supervisor(AbsintheTraceReporter, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExampleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

Add Trace Collector to the Absinthe pipeline in the router`
```
  match("/api",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [
      schema: Example.Schema,
      json_codec: Jason,
      interface: :playground,
      pipeline: {AbsintheTraceReporter.Pipeline, :default}
    ]
  )
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/absinthe_tracing_reporter](https://hexdocs.pm/absinthe_tracing_reporter).

