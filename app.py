from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Hello, Dockerized FastAPI!"}


@app.get("/health")
def health_check():
    return {"status": "ok"}
# This file is part of the Build-Static-Scan-and-Push-Docker-Image-SonarCloud project.
