#!/bin/bash

# Variables
DOMAIN_NAME="app.judgefest.com"
DB_NAME="judgefest"
BACKUP_PATH="$HOME/backups"
DB_BACKUP_PATH="$BACKUP_PATH/db"
CONFIG_BACKUP_PATH="$BACKUP_PATH/config"
REMOTE_APP_PATH="/usr/share/judgefest"
REMOTE_APP_PATH_GO="$REMOTE_APP_PATH/go"

# SSH connection
ssh -T $DOMAIN_NAME "./backup.sh"

# Create backup directories if they don't exist
mkdir -p "$DB_BACKUP_PATH"
mkdir -p "$CONFIG_BACKUP_PATH"

# Copy database backup to local machine
rsync -avz $DOMAIN_NAME:/tmp/backups/ "$BACKUP_PATH"
