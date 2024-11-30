defmodule ElixirDockerAppTwo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirDockerAppTwoWeb.Telemetry,
      ElixirDockerAppTwo.Repo,
      {DNSCluster, query: Application.get_env(:elixir_docker_app_two, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirDockerAppTwo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirDockerAppTwo.Finch},
      # Start a worker by calling: ElixirDockerAppTwo.Worker.start_link(arg)
      # {ElixirDockerAppTwo.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirDockerAppTwoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirDockerAppTwo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirDockerAppTwoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
