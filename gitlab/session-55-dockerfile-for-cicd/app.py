from flask import Flask

app = Flask(__name__)


@app.get("/")
def index():
    return {"message": "CI/CD Dockerfile Lab"}, 200


@app.get("/health")
def health():
    return {"status": "ok"}, 200
