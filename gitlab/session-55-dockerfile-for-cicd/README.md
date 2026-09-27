# Session 55 — Dockerfile for CI/CD

Chapter 7: Docker Build in GitLab CI/CD

This lab focuses on designing a Dockerfile that is suitable for CI/CD and production-oriented workflows.

## Topics

- Standard Dockerfile structure
- Base image selection
- Minimal images
- Docker layers and cache-friendly instruction ordering
- `.dockerignore`
- Multi-stage builds
- Non-root containers
- Secret and proxy handling best practices

## Lab Files

- `app.py` — Flask application with root and health endpoints
- `requirements.txt` — Python runtime dependencies
- `Dockerfile` — multi-stage, non-root, cache-friendly production Dockerfile
- `.dockerignore` — excludes unnecessary and sensitive files from the build context
- `DevOps_Dockerfile_CI-CD_Session_55_Commands_CheatSheet.txt` — commands and Dockerfile instructions used in this lesson

## Build

```bash
docker build -t cicd-flask:1.0 .
```

## Run

```bash
docker run -d \
  --name cicd-flask \
  -p 8000:8000 \
  cicd-flask:1.0
```

## Verify

```bash
curl http://localhost:8000/
curl http://localhost:8000/health
docker exec cicd-flask whoami
```

The application should run as the non-root user `app`.
