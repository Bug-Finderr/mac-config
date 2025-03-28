#!/bin/bash

ZSHRC_PATH="$HOME/.zshrc"
BACKUP_DIR="$HOME/tweaks/backup_zshrc/actual_backups/"
MAX_BACKUPS=10

# Les bigint!
mkdir -p "$BACKUP_DIR"

create_backup() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/zshrc_backup_$TIMESTAMP"
    cp "$ZSHRC_PATH" "$BACKUP_FILE"
    echo "Backup created: $BACKUP_FILE"

    # Remove old backups if exceeding MAX_BACKUPS
    BACKUP_COUNT=$(ls -1 "$BACKUP_DIR" | wc -l)
    if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
        OLDEST_BACKUP=$(ls -1t "$BACKUP_DIR" | tail -1)
        rm "$BACKUP_DIR/$OLDEST_BACKUP"
        echo "Old backup removed: $OLDEST_BACKUP"
    fi
}

echo "Monitoring $ZSHRC_PATH for changes..."
fswatch -o "$ZSHRC_PATH" | while read -r; do
    create_backup
done