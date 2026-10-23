#!/bin/bash
# One-time server setup for Amazon Linux 2023.
# Run from the repo folder: cd ~/aramba && bash deploy/setup.sh
set -e

sudo dnf install -y python3.12 nginx

python3.12 -m venv .venv
.venv/bin/pip install -r requirements.txt

sudo cp deploy/aramba.service /etc/systemd/system/aramba.service
sudo cp deploy/nginx.conf /etc/nginx/conf.d/aramba.conf
sudo nginx -t

sudo systemctl daemon-reload
sudo systemctl enable aramba nginx
sudo systemctl restart aramba nginx

sleep 2
curl localhost/api/health
