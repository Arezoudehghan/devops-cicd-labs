import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        message="Hello from GitLab CI",
        environment=os.getenv("APP_ENV", "development"),
    )


@app.get("/health")
def health():
    return jsonify(
        status="ok",
        environment=os.getenv("APP_ENV", "development"),
        version=os.getenv("APP_VERSION", "local"),
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
