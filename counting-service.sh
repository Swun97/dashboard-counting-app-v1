#!/bin/bash

# Log everything
exec > /var/log/counting-service.log 2>&1
set -ex

echo "Starting counting service setup"

# 🔥 Wait until internet is available
until curl -s http://google.com > /dev/null; do
  echo "Waiting for internet..."
  sleep 5
done

echo "Internet is ready"

# Update packages (force IPv4)
sudo apt -o Acquire::ForceIPv4=true update -y

# Install dependencies
sudo apt install -y net-tools zip curl jq tree unzip wget siege \
apt-transport-https ca-certificates software-properties-common \
gnupg lsb-release

# Download counting service
curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip -o counting-service.zip

# Extract
unzip counting-service.zip

# Cleanup
rm -f counting-service.zip

# Move binary
sudo mv counting-service_linux_amd64 /usr/bin/counting-service
sudo chmod +x /usr/bin/counting-service
sudo chown ubuntu:ubuntu /usr/bin/counting-service

# Create systemd service
sudo tee /etc/systemd/system/counting-api.service > /dev/null <<EOF
[Unit]
Description=Counting API service
After=network.target

[Service]
Environment=PORT=8888
ExecStart=/usr/bin/counting-service
User=ubuntu
Group=ubuntu
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable counting-api.service
sudo systemctl restart counting-api.service

# Check status
sleep 2
sudo systemctl status counting-api.service

# Optional: verify listening port
sudo lsof -i -P | grep counting