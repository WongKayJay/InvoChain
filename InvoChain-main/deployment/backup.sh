#!/bin/bash

###############################################################################
# InvoChain Backup Script
# Purpose: Automated backups for g1t2.drshaiban.cloud deployment
# Schedule: Run daily via cron (recommended: 2 AM)
# Crontab: 0 2 * * * /usr/local/bin/backup-invochain.sh
###############################################################################

# Configuration
BACKUP_DIR="/var/backups/invochain"
SOURCE_DIR="/var/www/invochain"
RETENTION_DAYS=30  # Keep backups for 30 days
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="invochain_backup_${DATE}"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Logging
LOG_FILE="/var/log/invochain-backup.log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "========================================="
echo "InvoChain Backup Script"
echo "Started: $(date)"
echo "========================================="

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Create temporary backup directory
TEMP_BACKUP="$BACKUP_DIR/$BACKUP_NAME"
mkdir -p "$TEMP_BACKUP"

echo "Creating backup in: $TEMP_BACKUP"

# Backup website files
echo "Backing up website files..."
if [ -d "$SOURCE_DIR/website" ]; then
    cp -r "$SOURCE_DIR/website" "$TEMP_BACKUP/"
    echo "✓ Website backed up"
else
    echo "⚠ Website directory not found"
fi

# Backup Flutter app
echo "Backing up Flutter app..."
if [ -d "$SOURCE_DIR/app" ]; then
    cp -r "$SOURCE_DIR/app" "$TEMP_BACKUP/"
    echo "✓ Flutter app backed up"
else
    echo "⚠ Flutter app directory not found"
fi

# Backup Nginx configuration
echo "Backing up Nginx configuration..."
if [ -f "/etc/nginx/sites-available/invochain" ]; then
    mkdir -p "$TEMP_BACKUP/config"
    cp "/etc/nginx/sites-available/invochain" "$TEMP_BACKUP/config/"
    echo "✓ Nginx config backed up"
fi

# Backup SSL certificates (optional)
echo "Backing up SSL certificates..."
if [ -d "/etc/letsencrypt/live/g1t2.drshaiban.cloud" ]; then
    mkdir -p "$TEMP_BACKUP/ssl"
    cp -rL "/etc/letsencrypt/live/g1t2.drshaiban.cloud" "$TEMP_BACKUP/ssl/"
    echo "✓ SSL certificates backed up"
fi

# Create compressed archive
echo "Compressing backup..."
cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"

# Remove temporary directory
rm -rf "$TEMP_BACKUP"

# Calculate backup size
BACKUP_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
echo "✓ Backup compressed: ${BACKUP_SIZE}"

# Remove old backups (older than RETENTION_DAYS)
echo "Cleaning up old backups (keeping last ${RETENTION_DAYS} days)..."
find "$BACKUP_DIR" -name "invochain_backup_*.tar.gz" -type f -mtime +${RETENTION_DAYS} -delete
REMAINING_BACKUPS=$(ls -1 "$BACKUP_DIR"/invochain_backup_*.tar.gz 2>/dev/null | wc -l)
echo "✓ Remaining backups: $REMAINING_BACKUPS"

# Optional: Upload to remote storage (uncomment and configure)
# echo "Uploading to remote storage..."
# scp "${BACKUP_NAME}.tar.gz" backup-server:/backups/invochain/
# echo "✓ Uploaded to remote storage"

# Optional: Upload to AWS S3 (uncomment and configure)
# echo "Uploading to AWS S3..."
# aws s3 cp "${BACKUP_NAME}.tar.gz" s3://your-bucket/invochain-backups/
# echo "✓ Uploaded to S3"

echo "========================================="
echo "Backup completed: $(date)"
echo "Backup file: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo "Backup size: $BACKUP_SIZE"
echo "========================================="

# Send notification (optional - requires mail utility)
# echo "InvoChain backup completed successfully" | mail -s "Backup Success" admin@yourdomain.com

exit 0
