#!/bin/bash

# ===========================================
# Systemd Service Installation Script
# ===========================================
# Installs and enables fileserver to start on boot

set -e

# Get the absolute path of the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "========================================="
echo "  Installing Fileserver Systemd Service"
echo "========================================="
echo ""
echo "Project directory: $PROJECT_DIR"
echo ""

# Create systemd service file
sudo tee /etc/systemd/system/fileserver.service > /dev/null << EOF
[Unit]
Description=File Server (File Browser + Ngrok)
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$PROJECT_DIR
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

echo "✓ Service file created: /etc/systemd/system/fileserver.service"

# Reload systemd
sudo systemctl daemon-reload
echo "✓ Systemd reloaded"

# Enable service
sudo systemctl enable fileserver.service
echo "✓ Service enabled for boot"

# Start service
sudo systemctl start fileserver.service
echo "✓ Service started"

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "Service commands:"
echo "  Status:   sudo systemctl status fileserver"
echo "  Start:    sudo systemctl start fileserver"
echo "  Stop:     sudo systemctl stop fileserver"
echo "  Restart:  sudo systemctl restart fileserver"
echo "  Logs:     docker compose logs -f"
echo ""
echo "Service will now start automatically on boot!"
echo ""
