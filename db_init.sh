#!/bin/bash

# Set the database name and user
db_name=$1
db_user=$2

# Check that both arguments are provided
if [[ -z $1 || -z $2 ]]; then
  echo "Usage: $0 <db_name> <db_user>"
  exit 1
fi
# Define a function to spin up a PostgreSQL container
function start_postgresql() {
  echo "Initializing database: $db_user@$db_name"
  # Check if Docker daemon is running
  if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
  fi
  # Generate a random password for the database
  local db_password=$(openssl rand -base64 16 | tr -d '=|!&+/;$\\`"''')


  # Find a free port to forward to the PostgreSQL container
  local port=$(find_free_port)

  # Set the Docker container name as "$db_name"-db
  # Check if the database name ends with "db" already
  if [[ $db_name == *db ]]; then
    container_name=$db_name
  else
    container_name=${db_name}-db
  fi

  # Start the PostgreSQL container with the given password, port, and database name
  docker run -d --name "$container_name" -e POSTGRES_PASSWORD="$db_password" -e POSTGRES_USERNAME="db_user" -e POSTGRES_DB="$db_name" -p "$port":5432 postgres:latest
  local uri="postgresql://$db_user:$db_password@localhost:$port/$db_name"
  # Save the connection details to an environment file
  cat >.db.env <<EOF
DB_NAME=$db_name
DB_USER=$db_name
DB_PASSWORD=$db_password
DB_HOST=localhost
DB_PORT=$port
DB_URI=$uri
EOF

  echo "Started PostgreSQL db container, $db_name, with password $db_password on port $port"
  echo "Created .db.env file with connection details"
  echo "PostgreSQL URI: $uri"
  local psql_cmd="psql -h localhost -p $port -U $db_name -W $db_name"
  echo "Run the following command to connect to the PostgreSQL database:"
  echo "$psql_cmd"
}

# Define a function to find a free port to use
function find_free_port() {
  # Start from port 5432 and increment until we find a free port
  local port=5432
  while netstat -ant | grep -qE "\b${port}\b"; do
    port=$((port + 1))
  done
  echo "$port"
}

start_postgresql
