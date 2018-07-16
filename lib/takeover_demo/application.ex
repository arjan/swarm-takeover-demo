defmodule TakeoverDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: TakeoverDemo.Worker.start_link(arg)
      # {TakeoverDemo.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TakeoverDemo.Supervisor]

    spawn(fn ->
      # hacky -> connect
      Process.sleep 100
      Node.connect(:"a@127.0.0.1")
    end)

    Supervisor.start_link(children, opts)
  end
end
