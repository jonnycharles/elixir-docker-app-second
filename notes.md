1. .env file should like this:
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=postgres
    POSTGRES_DB=my_app_name
    DATABASE_URL=ecto://postgres:postgres@db/elixir_docker_app
    SECRET_KEY_BASE=secret_key_base
    PHX_HOST=localhost
    PORT=4000

2. Set secret_key_base to the result of :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64) in iex

3. Make sure the .env is in docker/dev folder

4. Run using docker compose -f docker/dev/docker-compose.yml up --build

