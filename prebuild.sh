#!/bin/bash


# Check if a hostname was passed as an argument
if [ -n "$1" ]; then
    HOSTNAME="$1"
else
    HOSTNAME=$(hostname)
fi

# Define paths
TEMPLATE_COMPOSE="materials/docker-compose-template.yml"
DEST_COMPOSE="./docker-compose.yml"

TEMPLATE_ENV="materials/.env-template"
DEST_ENV="./.env"


# --- Process docker-compose.yml ---
if [ ! -s "$TEMPLATE_COMPOSE" ]; then
    echo "❌ Error: Template file '$TEMPLATE_COMPOSE' not found or empty."
    exit 1
fi

cp "$TEMPLATE_COMPOSE" "$DEST_COMPOSE"
sed -i.bak "s|<HOSTNAME>|$HOSTNAME|g" "$DEST_COMPOSE"
rm -f "${DEST_COMPOSE}.bak"
echo "✅ docker-compose.yml generated with hostname: $HOSTNAME"

# --- Process .env ---
if [ -s "$TEMPLATE_ENV" ]; then
    cp "$TEMPLATE_ENV" "$DEST_ENV"
    sed -i.bak "s|<HOSTNAME>|$HOSTNAME|g" "$DEST_ENV"
    rm -f "${DEST_ENV}.bak"
    echo "✅ .env file generated with hostname: $HOSTNAME"
else
    echo "⚠️  Skipped .env generation — template '$TEMPLATE_ENV' not found or empty."
fi


