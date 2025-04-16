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

# Generate random admin username and password
OUTLINEADMINUSER="admin_$(tr -dc a-z0-9 </dev/urandom | head -c 6)"
OUTLINEADMINPASSWORD="$(tr -dc 'A-Za-z0-9!@#$%^&*()_+=' </dev/urandom | head -c 16)"

# --- Process docker-compose.yml ---
if [ ! -s "$TEMPLATE_COMPOSE" ]; then
	echo "❌ Error: Template file '$TEMPLATE_COMPOSE' not found or empty."
	exit 1
fi

cp "$TEMPLATE_COMPOSE" "$DEST_COMPOSE"
sed -i.bak \
	-e "s|<HOSTNAME>|$HOSTNAME|g" \
	-e "s|<OUTLINEADMINUSER>|$OUTLINEADMINUSER|g" \
	-e "s|<OUTLINEADMINPASSWORD>|$OUTLINEADMINPASSWORD|g" \
	"$DEST_COMPOSE"
rm -f "${DEST_COMPOSE}.bak"
echo "✅ docker-compose.yml generated with hostname and credentials."

# --- Process .env ---
if [ -s "$TEMPLATE_ENV" ]; then
	cp "$TEMPLATE_ENV" "$DEST_ENV"
	sed -i.bak \
    	-e "s|<HOSTNAME>|$HOSTNAME|g" \
    	-e "s|<OUTLINEADMINUSER>|$OUTLINEADMINUSER|g" \
    	-e "s|<OUTLINEADMINPASSWORD>|$OUTLINEADMINPASSWORD|g" \
    	"$DEST_ENV"
	rm -f "${DEST_ENV}.bak"
	echo "✅ .env file generated with hostname and credentials."
else
	echo "⚠️  Skipped .env generation — template '$TEMPLATE_ENV' not found or empty."
fi

# Output the credentials for reference
echo "🔐 Generated credentials:"
echo "  Username: $OUTLINEADMINUSER"
echo "  Password: $OUTLINEADMINPASSWORD"



