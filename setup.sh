#!/bin/bash

# ===========================================
# File Server Setup Script
# ===========================================
# This script generates the .env configuration file

set -e

echo ""
echo "========================================="
echo "  File Server Setup"
echo "========================================="
echo ""

# Data Directory
echo "Enter the path to your data directory:"
read -p "[default: /home/$USER/data]: " DATA_DIR
DATA_DIR=${DATA_DIR:-/home/$USER/data}

# Create data directory if it doesn't exist
if [ ! -d "$DATA_DIR" ]; then
    echo "Creating data directory: $DATA_DIR"
    mkdir -p "$DATA_DIR"
fi

echo ""
echo "Enter your Ngrok auth token:"
echo "(Get it from: https://dashboard.ngrok.com/get-started/your-authtoken)"
read -p "Token: " NGROK_TOKEN

echo ""
echo "Enter your Ngrok domain (optional):"
echo "(Leave empty to use random ngrok URL)"
read -p "Domain: " NGROK_DOMAIN

echo ""
echo "Enter SMB/Samba credentials for network file sharing:"
read -p "Username [default: $USER]: " SMB_USER
SMB_USER=${SMB_USER:-$USER}
read -sp "Password: " SMB_PASSWORD
echo ""

echo ""
echo "Enter user ID (UID) for Docker containers:"
CURRENT_UID=$(id -u)
read -p "[default: $CURRENT_UID]: " PUID
PUID=${PUID:-$CURRENT_UID}

echo ""
echo "Enter group ID (GID) for Docker containers:"
CURRENT_GID=$(id -g)
read -p "[default: $CURRENT_GID]: " PGID
PGID=${PGID:-$CURRENT_GID}
echo ""

# Generate .env file
cat > .env << EOF

# ===========================================
# File Server Environment Configuration
# ===========================================
# DO NOT commit .env to version control!

# -------------------------------------------
# Data Directory
# -------------------------------------------
DATA_DIRECTORY=$DATA_DIR

# -------------------------------------------
# Ngrok Configuration
# -------------------------------------------
NGROK_AUTHTOKEN=$NGROK_TOKEN
EOF

# Add domain only if provided
if [ -n "$NGROK_DOMAIN" ]; then
    echo "NGROK_DOMAIN=$NGROK_DOMAIN" >> .env
fi

cat >> .env << EOF

# -------------------------------------------
# SMB/Samba Configuration
# -------------------------------------------
SMB_USER=$SMB_USER
SMB_PASSWORD=$SMB_PASSWORD

# -------------------------------------------
# User/Group IDs (for Docker container permissions)
# -------------------------------------------
PUID=$PUID
PGID=$PGID
USERNAME=$SMB_USER
USERID=$PUID
GROUPID=$PGID

# -------------------------------------------
# Ports
# -------------------------------------------
NGROK_DASHBOARD_PORT=4040
FILEBROWSER_PORT=8081
EOF

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Configuration saved to .env"
echo ""
echo "Next steps:"
echo "  1. Start services:  docker compose up -d"
echo "  2. Access locally:  http://localhost:8081"
if [ -n "$NGROK_DOMAIN" ]; then
    echo "  3. Access online:   https://$NGROK_DOMAIN"
else
    echo "  3. Get public URL:  curl -s http://localhost:4040/api/tunnels | grep public_url"
fi
echo ""
echo "Default login: admin / adminadmin123"
echo "Change password after first login!"
echo ""
