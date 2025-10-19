#!/bin/bash

# ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: This script must be run as root!"
    exit 1
fi

# ensure systemd is available
if ! command -v systemctl &> /dev/null; then
    echo "Error: systemd is not available on this system."
    exit 1
fi

echo "Starting system-backup installation..."

# creating configuration file
echo "Copying config file to /etc/system-backup/config.conf..."
mkdir -p /etc/system-backup
cp src/config.conf /etc/system-backup/config.conf
chmod 600 /etc/system-backup/config.conf

# copy main script
echo "Copying main script to /usr/local/bin/system-backup.sh..."
cp src/system-backup.sh /usr/local/bin/system-backup.sh
chmod +x /usr/local/bin/system-backup.sh

# setting up systemd service
echo "Copying systemd service and timer files and setting up deamon..."
cp src/openvpn-notify.service /etc/systemd/system/system-backup.service
cp src/openvpn-notify.timer /etc/systemd/system/system-backup.timer
systemctl daemon-reload
systemctl enable system-backup
systemctl start system-backup

# successful exit
echo "system-backup installation finished!"
exit 0
