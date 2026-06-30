#!/bin/bash
export TMPDIR=/data/data/com.termux/files/home/.tmp
LOG_FILE="$HOME/warehouse/logs/backup_$(date +%Y%m%d).log"

echo "💾 BACKUP STARTED: $(date)" | tee -a $LOG_FILE

# Sync Google Drives to backup warehouse
for remote in gdrive1 gdrive2 gdrive3; do
    echo "📤 Syncing $remote..." | tee -a $LOG_FILE
    rclone sync $remote:/ warehouse-backup:/$remote/ \
        --exclude ".Trash/**" \
        --exclude "*.tmp" \
        --verbose 2>> $LOG_FILE
done

echo "✅ BACKUP COMPLETE: $(date)" | tee -a $LOG_FILE
