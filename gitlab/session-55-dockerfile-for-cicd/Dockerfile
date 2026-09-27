# syntax=docker/dockerfile:1

FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .

RUN python -m pip wheel \
    --wheel-dir /wheels \
    -r requirements.txt


FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN groupadd --system --gid 10001 app && \
    useradd \
      --system \
      --uid 10001 \
      --gid app \
      --create-home \
      app

COPY --from=builder /wheels /wheels

RUN python -m pip install \
    --no-cache-dir \
    /wheels/* && \
    rm -rf /wheels

COPY --chown=app:app app.py .

USER app

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
