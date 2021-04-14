defmodule NotUnoServer.Application do

  use Application

  def start(_type, _args) do
    children = [
      {NotUnoServer.Supervisor, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NotUnoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end