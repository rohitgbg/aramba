#!/bin/bash
# Pull the latest code and restart the app. Run on the server: bash /opt/aramba/deploy/update.sh
set -euo pipefail

cd /opt/aramba
sudo -u aramba git pull
sudo -u aramba .venv/bin/pip install -r requirements.txt
sudo systemctl restart aramba
systemctl status aramba --no-pager
