
from fastapi import FastAPI

app = FastAPI(
    title="Aramba API",
    description="API for the Aramba AI data workspace",
    version="0.1.0",
)


@app.get("/")
def root():
    return {
        "name": "Aramba API",
        "message": "Welcome to Aramba",
        "version": "0.1.0",
    }


@app.get("/health")
def health_check():
    return {
        "status": "ok",
    }

@app.get("/hello/{name}")
def hello(name: str):
    return {"status": f"Hello {name}"}