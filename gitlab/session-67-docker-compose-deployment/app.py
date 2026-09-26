import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        message="CI/CD Session 67 - Docker Compose Deployment",
        version=os.getenv("APP_VERSION", "unknown"),
        environment=os.getenv("APP_ENV", "development"),
    )


@app.get("/health")
def health():
    return jsonify(status="ok", version=os.getenv("APP_VERSION", "unknown")), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
