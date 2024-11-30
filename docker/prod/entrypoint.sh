#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check database readiness
check_db() {
  max_attempts=60  # Maximum number of attempts (2 minutes with 2-second sleep)
  attempt=1

  until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do
    echo "Waiting for Postgres to be ready... (Attempt: $attempt/$max_attempts)"

    attempt=$((attempt + 1))
    if [ $attempt -gt $max_attempts ]; then
      echo "Timeout reached waiting for Postgres to become ready"
      exit 1
    fi

    sleep 2
  done
}

# Wait for the database to be ready
check_db

# Run database migrations
echo "Running migrations..."
bin/my_app eval "MyApp.Release.migrate"

# Start the application
echo "Starting application..."
exec bin/my_app start
