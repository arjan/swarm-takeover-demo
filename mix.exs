defmodule TakeoverDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :takeover_demo,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TakeoverDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:swarm, github: "semlabs/swarm", branch: "feature/graceful-shutdown"},
      {:graceful_stop, "~> 0.1"}
    ]
  end
end
