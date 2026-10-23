#!/bin/bash
# First-boot setup for an Ubuntu EC2 instance. Paste into "User data" when launching.
# Runs as root. Output is logged to /var/log/cloud-init-output.log
set -euxo pipefail

REPO_URL="https://github.com/rohitgbg/aramba.git"
APP_DIR="/opt/aramba"

apt-get update
apt-get install -y git python3-venv nginx

# Dedicated user with no login shell, so the app can't do more than it needs to
useradd --system --no-create-home --shell /usr/sbin/nologin aramba

git clone "$REPO_URL" "$APP_DIR"
chown -R aramba:aramba "$APP_DIR"

sudo -u aramba python3 -m venv "$APP_DIR/.venv"
sudo -u aramba "$APP_DIR/.venv/bin/pip" install -r "$APP_DIR/requirements.txt"

cp "$APP_DIR/deploy/aramba.service" /etc/systemd/system/aramba.service
systemctl daemon-reload
systemctl enable --now aramba

cp "$APP_DIR/deploy/nginx.conf" /etc/nginx/sites-available/aramba
ln -sf /etc/nginx/sites-available/aramba /etc/nginx/sites-enabled/aramba
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx
