defmodule ElixirDockerAppTwo.Repo do
  use Ecto.Repo,
    otp_app: :elixir_docker_app_two,
    adapter: Ecto.Adapters.Postgres
end
