#!/bin/bash

BACKUP_DIR="/mnt/backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
DEST="$BACKUP_DIR/sys_backup_$TIMESTAMP"
CONFIG_FILE="/etc/system-backup/config.conf"

# load config file
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file $CONFIG_FILE not found! Retrying in 30 seconds..." | systemd-cat -t system-backup -p err
    exit 1
fi

# load telegram credentials
source "$CONFIG_FILE"

# sending telegram notification
telegram_message() {
    local MESSAGE="$1"
    local URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"

    RESPONSE=$(curl -s -X POST "$URL" -d chat_id="$CHAT_ID" -d text="$MESSAGE")
    if [[ "$RESPONSE" != *"\"ok\":true"* ]]; then
        echo "Failed to send Telegram message: $RESPONSE" | systemd-cat -t system-backup -p err
    fi
}

# send telegram notification
telegram_message "Starting system backup at $DEST"

# rotate backups: keep only the most recent
cd "$BACKUP_DIR"
ls -dt sys_backup_* | tail -n +2 | xargs -d '\n' rm -rf --

# new backup folder
mkdir -p "$DEST"

# rsync backup
rsync -aAXv / \
  --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/swapfile"} \
  "$DEST" > /dev/null

if [ $? -ne 0 ]; then
  echo "System backup FAILED" | systemd-cat -t system-backup -p err
  telegram_message "System backup FAILED"
  exit 1
fi

# send telegram notification
telegram_message "System backup completed"

exit 0
