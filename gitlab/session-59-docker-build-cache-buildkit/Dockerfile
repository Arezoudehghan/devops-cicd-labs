# syntax=docker/dockerfile:1

FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install \
    --disable-pip-version-check \
    -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
