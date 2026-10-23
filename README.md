
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

## Deploy to EC2 (Amazon Linux 2023)

The server runs two things:

- `http://<public-ip>/` — your web page (files in `/usr/share/nginx/html`)
- `http://<public-ip>/api/` — this API (e.g. `/api/health`, `/api/docs`)

Nginx listens on port 80 and forwards `/api/` requests to the app on port 8000. systemd keeps the app running.

### 1. Launch the instance

- AMI: **Amazon Linux 2023**, instance type: `t3.micro`
- Security group: **SSH (22)** from your IP, **HTTP (80)** from anywhere

### 2. Set up the server

```bash
ssh -i mykey.pem ec2-user@<public-ip>

sudo dnf install -y git
git clone https://github.com/rohitgbg/aramba.git
cd aramba
bash deploy/setup.sh
```

The last line should print `{"status":"ok"}`. The repo must be cloned to `/home/ec2-user/aramba`, because [`deploy/aramba.service`](deploy/aramba.service) uses that path.

### 3. Update after pushing new code

```bash
cd ~/aramba && git pull && sudo systemctl restart aramba
```

If `requirements.txt` changed, also run `.venv/bin/pip install -r requirements.txt` before restarting.

### Troubleshooting

| Problem | Check |
|---|---|
| `502 Bad Gateway` | The app is down: `sudo systemctl status aramba` |
| App logs | `sudo journalctl -u aramba -f` |
| Nginx won't start | `sudo nginx -t` shows the config error |
| Page doesn't load at all | Port 80 allowed in the security group? |
