# Session 67 — Deployment with Docker Compose

This lab deploys a versioned Docker image from Nexus to the DEV-2 deployment server with Docker Compose after GitLab CI builds and pushes the image from DEV-1.

## Topics

- Docker Compose in deployment
- `compose.yaml`
- `docker compose pull`
- `docker compose up`
- `docker compose down`
- `docker compose restart`
- Environment files
- Commit-based image version management
- Remote deployment over SSH
- Health-aware deployment and rollback

## Lab Environment

### DEV-1

- IP: `192.168.94.90`
- GitLab CE
- GitLab Runner
- Shell executor
- Runner tag: `dev-shell`
- Docker
- Nexus Docker Registry: `192.168.94.90:8085`

### DEV-2

- IP: `192.168.94.91`
- Docker deployment server
- Deploy user: `deploy`
- Deployment path: `/opt/cicd-app`
- Published application port: `8088`

## Pipeline Flow

```text
Build
  ↓
Push immutable image to Nexus
  ↓
SSH to DEV-2
  ↓
Generate .env
  ↓
Validate Compose configuration
  ↓
docker compose pull
  ↓
docker compose up -d --remove-orphans --wait --wait-timeout 60
  ↓
docker compose ps
```

## Version Management

The image tag is based on `CI_COMMIT_SHORT_SHA` instead of `latest`.

Example:

```text
192.168.94.90:8085/cicd-app:83d521a
```

This keeps each deployment traceable to a Git commit and makes rollback possible by selecting the previous image tag.

## Environment Files

- `.env` is used by Docker Compose for variable interpolation and is generated on DEV-2 by the pipeline.
- `app.env` contains application environment variables passed into the container.
- `.env.previous` stores the previous Compose environment values for the rollback example.
- Real `.env` and `app.env` files are intentionally excluded from Git. Use the included example files as templates.

## GitLab CI/CD Variables

The pipeline expects these values to be configured in GitLab CI/CD variables:

- `DEPLOY_HOST=192.168.94.91`
- `DEPLOY_USER=deploy`
- `DEPLOY_PATH=/opt/cicd-app`
- `NEXUS_REGISTRY=192.168.94.90:8085`
- `NEXUS_USER`
- `NEXUS_PASSWORD`
- `APP_PORT=8088`
- `SSH_PRIVATE_KEY` as a File variable
- `SSH_KNOWN_HOSTS` as a File variable
- `APP_ENV_FILE` as a File variable

The build job also uses `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY` when those variables are configured for the lab environment.

## Files

- `.gitlab-ci.yml` — build, push, SSH, Compose pull/up, health wait, and status verification pipeline
- `compose.yaml` — versioned application deployment definition
- `app.py` — small Flask application with `/` and `/health` endpoints for the lab
- `requirements.txt` — Python dependency list
- `Dockerfile` — Python image used by the build stage
- `.env.example` — example Compose interpolation values
- `app.env.example` — example application environment values
- `.gitignore` — excludes runtime environment files
- `.dockerignore` — excludes local/runtime files from the Docker build context
- `DevOps_Docker_Compose_Deployment_Session_67_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations
