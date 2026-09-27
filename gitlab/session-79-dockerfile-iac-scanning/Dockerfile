FROM python:3.12-slim

WORKDIR /app

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup appuser

COPY --chown=appuser:appgroup . .

RUN pip install --no-cache-dir -r requirements.txt

USER appuser

CMD ["python", "app.py"]
