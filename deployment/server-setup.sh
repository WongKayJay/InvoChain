#!/bin/bash

###############################################################################
# InvoChain Server Setup Script
# Purpose: Automated server configuration for g1t2.drshaiban.cloud
# Usage: curl -fsSL https://raw.githubusercontent.com/WongKayJay/InvoChain/main/deployment/server-setup.sh | bash
###############################################################################

set -e

echo "========================================="
echo "InvoChain Server Setup"
echo "========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo"
    exit 1
fi

# Update system
echo "[1/7] Updating system packages..."
apt update && apt upgrade -y

# Install Nginx
echo "[2/7] Installing Nginx..."
apt install -y nginx

# Install Git
echo "[3/7] Installing Git..."
apt install -y git

# Install Certbot for SSL
echo "[4/7] Installing Certbot..."
apt install -y certbot python3-certbot-nginx

# Configure firewall
echo "[5/7] Configuring firewall..."
ufw --force enable
ufw allow OpenSSH
ufw allow 'Nginx Full'

# Create directory structure
echo "[6/7] Creating directories..."
mkdir -p /var/www/invochain/website
mkdir -p /var/www/invochain/app
mkdir -p /var/backups/invochain

# Set permissions
echo "[7/7] Setting permissions..."
chown -R www-data:www-data /var/www/invochain
chmod -R 755 /var/www/invochain

echo ""
echo "========================================="
echo "✓ Server setup completed!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Deploy your files to /var/www/invochain/"
echo "2. Configure Nginx (see deployment/nginx.conf)"
echo "3. Get SSL certificate with: certbot --nginx -d g1t2.drshaiban.cloud"
echo ""
echo "Useful commands:"
echo "  - Check Nginx status: systemctl status nginx"
echo "  - View logs: tail -f /var/log/nginx/error.log"
echo "  - Test config: nginx -t"
echo ""
