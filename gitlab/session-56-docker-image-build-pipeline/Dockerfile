FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN python -m pip install \
    --no-cache-dir \
    --disable-pip-version-check \
    --trusted-host pypi.org \
    --trusted-host files.pythonhosted.org \
    -r requirements.txt

COPY . .

ARG APP_VERSION

LABEL org.opencontainers.image.version="${APP_VERSION}"

EXPOSE 5000

CMD ["python", "app.py"]
