
# Aramba API

Backend API for the Aramba AI data workspace.

## Requirements

- Python 3.10+

## Setup

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run locally

```bash
uvicorn app.main:app --reload
```

## Endpoints

- `GET /` — API information
- `GET /health` — Health check
- `GET /docs` — Interactive API documentation

## Deploy to EC2

Request flow: `client → Nginx (:80/443) → Gunicorn (127.0.0.1:8000) → Uvicorn workers → FastAPI`

1. Launch an Ubuntu 24.04 `t3.micro`. Security group: SSH (22) from your IP, HTTP (80) and HTTPS (443) from anywhere.
2. Under **Advanced details → User data**, paste the contents of [`deploy/user-data.sh`](deploy/user-data.sh).
3. Wait ~2 minutes, then open `http://<public-ip>/health`.

Setup logs: `sudo tail -f /var/log/cloud-init-output.log`

### Useful commands on the server

```bash
sudo systemctl status aramba      # is the app running?
sudo journalctl -u aramba -f      # app logs
bash /opt/aramba/deploy/update.sh # deploy latest code from main
```

### HTTPS

Point your domain's A record at the instance's Elastic IP, set `server_name` in `/etc/nginx/sites-available/aramba`, then:

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com
```
