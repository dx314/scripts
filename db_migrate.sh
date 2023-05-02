#!/bin/bash

# Check if Gomigrate is installed and install it if necessary
if ! command -v migrate &>/dev/null; then
  echo "Gomigrate is not installed. Installing now..."
  exit;
fi

# Set the path to the .env file
if [[ -z $1 ]]; then
  env_path="./.db.env"
else
  env_path=$1
fi

# Check if the .env file exists
if [[ ! -f $env_path ]]; then
  echo "Error: $env_path not found."
  exit 1
fi

# Define a function to run Gomigrate with the given arguments
function dbmigrate() {
  # Check if the migrations folder exists

  local direction=$2
  local version=$3

  # Check if the direction argument is valid
  if [[ "$direction" != "up" && "$direction" != "down" ]]; then
    echo "Invalid direction argument: $direction. Use 'up' or 'down'."
    return 1
  fi

  # Check if the version argument is valid
  if [[ ! -z "$version" && ! "$version" =~ ^[0-9]+$ ]]; then
    echo "Invalid version argument. Use a positive integer or leave it empty."
    return 1
  fi

  if [[ ! -d "./migrations" ]]; then
    echo "Error: migrations folder not found."
    exit 1
  fi

  local db_name=$(grep -w DB_NAME $env_path | cut -d '=' -f2)
  local db_user=$(grep -w DB_USER $env_path | cut -d '=' -f2)
  local db_password=$(grep -w DB_PASSWORD $env_path | cut -d '=' -f2)
  local db_host=$(grep -w DB_HOST $env_path | cut -d '=' -f2)
  local db_port=$(grep -w DB_PORT $env_path | cut -d '=' -f2)

  # Construct the database connection string
  local connection_string="postgres://$db_user:$db_password@$db_host:$db_port/$db_name?sslmode=disable"

  # Print the Gomigrate command that will be executed
  echo "Running Gomigrate with the following command:"
  echo migrate -path migrations -database $connection_string $direction $version

  # Check if the .env file exists
  if [[ ! -f $version ]]; then
      migrate -path migrations -database $connection_string $direction $version
  else
      migrate -path migrations -database $connection_string $direction
  fi

  # Print a message indicating the status of the migration
  if [[ $? -eq 0 ]]; then
    echo "Migration completed successfully."
  else
    echo "Migration failed."
  fi
}

# Call the migrate function with the given arguments
dbmigrate "$@"
