#!/bin/bash
# Ensure Docker Compose uses the .env file
export $(grep -v '^#' default.env | xargs)

# Start the services
docker compose up -d
