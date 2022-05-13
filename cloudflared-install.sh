# Download
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo chown _apt:root cloudflared-linux-amd64.deb
sudo chmod 700 cloudflared-linux-amd64.deb

# Create a user
sudo useradd -r -M -s /usr/sbin/nologin -c "Cloudflared user" -U cloudflared
sudo passwd -l cloudflared
sudo chage -E 0 cloudflared

# Install 
sudo apt-get install ./cloudflared-linux-amd64.deb
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared 
sudo chmod 750 /usr/local/bin/cloudflared 

# Configure cloudflared
echo "CLOUDFLARED_OPTS=--address 127.0.0.1 --port 5353 --upstream https://1.1.1.2/dns-query --upstream https://1.0.0.2/dns-query" | sudo tee /etc/default/cloudflared
sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chmod 640 /etc/default/cloudflared
sudo chmod 755 /usr/local/bin

# Create startup script
echo '[Unit]
Description=cloudflared DNS over HTTPS proxy
After=syslog.target network-online.target
[Service]
Type=simple
User=cloudflared
EnvironmentFile=/etc/default/cloudflared
ExecStart=/usr/local/bin/cloudflared proxy-dns $CLOUDFLARED_OPTS
Restart=on-failure
RestartSec=10
KillMode=process
[Install]
WantedBy=multi-user.target' | sudo tee /lib/systemd/system/cloudflared.service
sudo chmod 644 /lib/systemd/system/cloudflared.service
sudo chown root:root /lib/systemd/system/cloudflared.service

# Create update script
echo '#!/bin/bash
/usr/local/bin/cloudflared update
sudo systemctl restart cloudflared' | sudo tee /etc/cron.daily/cloudflared-updater
sudo chmod 755 /etc/cron.daily/cloudflared-updater
sudo chown root:root /etc/cron.daily/cloudflared-updater

# Enable cloudflared and start
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared

# Clean the kitchen
sudo rm -r cloudflared-linux-amd64.deb