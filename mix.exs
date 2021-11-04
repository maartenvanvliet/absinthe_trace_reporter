defmodule AbsintheTraceReporter.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_trace_reporter,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:apollo_tracing, "~> 0.4.0"},
      {:absinthe_plug, "~> 1.4.5"},
      {:absinthe, "~> 1.4.0"},
      # Protocol buffers
      {:protobuf, "~> 0.8.0"},
      {:google_protos, "~> 0.1"},
      {:tesla, "~> 1.3.0"}
    ]
  end
end
