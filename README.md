
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

## Deploy to EC2 (beginner guide)

### Step 1: Run it by hand

1. Launch an **Ubuntu** `t3.micro` instance. In the security group, allow **SSH (22)** from your IP and **Custom TCP 8000** from anywhere.
2. Connect and set up the app:

```bash
ssh -i mykey.pem ubuntu@<public-ip>

sudo apt update && sudo apt install -y python3-venv
git clone https://github.com/rohitgbg/aramba.git
cd aramba
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

3. Open `http://<public-ip>:8000/docs` in your browser.

### Step 2: Keep it running with systemd

So the app keeps running after you close SSH, and starts again after a reboot:

```bash
sudo cp deploy/aramba.service /etc/systemd/system/
sudo systemctl enable --now aramba
sudo systemctl status aramba
```

### Step 3: Put Nginx in front

So people can visit `http://<public-ip>` without `:8000`. Allow **HTTP (80)** in the security group, then:

```bash
sudo apt install -y nginx
sudo cp deploy/nginx.conf /etc/nginx/sites-available/default
sudo systemctl restart nginx
```

### Updating the app

```bash
cd ~/aramba && git pull && sudo systemctl restart aramba
```
