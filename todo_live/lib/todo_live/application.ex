defmodule TodoLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TodoLiveWeb.Telemetry,
      # Start the Ecto repository
      TodoLive.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TodoLive.PubSub},
      # Start Finch
      {Finch, name: TodoLive.Finch},
      # Start the Endpoint (http/https)
      TodoLiveWeb.Endpoint
      # Start a worker by calling: TodoLive.Worker.start_link(arg)
      # {TodoLive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodoLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
