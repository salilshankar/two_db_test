defmodule TwoDbTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TwoDbTest.Repo.MySql,
      TwoDbTest.Repo.Scylla,
      # Start the Telemetry supervisor
      TwoDbTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TwoDbTest.PubSub},
      # Start the Endpoint (http/https)
      TwoDbTestWeb.Endpoint
      # Start a worker by calling: TwoDbTest.Worker.start_link(arg)
      # {TwoDbTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwoDbTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwoDbTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
