defmodule Estim8.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Estim8Web.Telemetry,
      # Start the Ecto repository
      Estim8.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Estim8.PubSub},
      # Start Finch
      {Finch, name: Estim8.Finch},
      # Start the Endpoint (http/https)
      Estim8Web.Endpoint,
      # Start a worker by calling: Estim8.Worker.start_link(arg)
      # {Estim8.Worker, arg}
      Estim8.RoomRegistry,
      Estim8.RoomMonitor,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Estim8.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Estim8Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
