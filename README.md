
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
