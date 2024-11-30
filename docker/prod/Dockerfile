# Stage 1: Build
FROM elixir:1.15-alpine AS build

# Install build dependencies
RUN apk add --no-cache build-base npm git

WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set production environment
ENV MIX_ENV=prod

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

COPY config config
COPY priv priv
RUN mix deps.compile

# Compile assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm install --prefix ./assets
COPY assets ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest

# Build the release
COPY lib lib
RUN mix release

# Stage 2: Release
FROM alpine:3.16 AS app

# Install runtime dependencies including postgresql-client
RUN apk add --no-cache openssl ncurses-libs postgresql-client

ENV MIX_ENV=prod \
    LANG=en_US.UTF-8 \
    PORT=4000

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/my_app ./

# Copy the entrypoint script
COPY docker/prod/entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 4000

ENTRYPOINT ["./entrypoint.sh"]
