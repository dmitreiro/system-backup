# system-backup
This service performs a schedule system backup using `rsync` and sends Telegram real-time notifications about the status of the backup.

***

## :gear: Setup

:warning: **Warning**: before you proceed, make sure your Linux OS uses `systemd` as a service manager.

Open terminal, change your current working directory to the location where you want the cloned directory and then clone this repository to your local machine

```
git clone https://github.com/dmitreiro/system-backup.git
```

Then, navigate to your repository home folder, give execution permission to `install.sh` and run it as sudo

```
chmod +x install.sh
sudo ./install.sh
```

When the installation finishes, edit `/etc/system-backup/config.conf` config file (open as sudo) and write your Telegram bot `token` and `chat_id`.

```
BOT_TOKEN="your_bot_token_here"
CHAT_ID="your_chat_id_here"
```

After setting up config file, restart systemd service to apply changes

```
sudo systemctl restart system-backup.service
```

Now, you are ready to rock :sunglasses:

To check service status run

```
sudo systemctl status system-backup.service
```

To check timer status run

```
sudo systemctl status system-backup.timer
```

To check service logs run

```
sudo journalctl -t system-backup -f

```

## :balance_scale: License

This project is licensed under the MIT License, which allows anyone to use, modify, and distribute this software for free, as long as the original copyright and license notice are included. See the [LICENSE](LICENSE) file for more details.
