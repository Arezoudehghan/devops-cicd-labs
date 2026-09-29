# Session 92 — Troubleshooting Deployment

Hands-on GitLab CI/CD deployment troubleshooting lab for Chapter 11: Troubleshooting and Performance.

## Lab Architecture

- **DEV-1 — 192.168.94.90**
  - GitLab CE
  - GitLab Runner
  - Shell executor
  - Runner tag: `dev-shell`
  - Nexus Docker Registry: `192.168.94.90:8085`

- **DEV-2 — 192.168.94.91**
  - Docker deployment server
  - SSH user: `deploy`
  - Application container: `cicd-app`
  - Host port: `8088`
  - Container port: `5000`

## Pipeline Flow

```text
deploy
  ↓
healthcheck
  ↓
smoke_test
  ↓
success

on failure
  ↓
rollback
  ↓
rollback healthcheck
```

## Troubleshooting Scenarios

This lab intentionally reproduces and diagnoses these deployment failures:

1. SSH Permission Denied
2. Host Key Failure
3. Wrong Private Key
4. Port Conflict
5. Docker Container Crash
6. Environment Variable Error
7. Healthcheck Failure
8. Smoke Test Failure

## Required GitLab CI/CD Variables

Create these variables in GitLab before running the pipeline:

- `SSH_PRIVATE_KEY` — **File Type** variable containing the deploy user's OpenSSH private key.
- `SSH_KNOWN_HOSTS` — **File Type** variable containing the verified SSH host key entry for `192.168.94.91`.

The pipeline already defines the non-secret lab values:

- `DEPLOY_HOST=192.168.94.91`
- `DEPLOY_USER=deploy`
- `APP_NAME=cicd-app`
- `APP_PORT=8088`
- `CONTAINER_PORT=5000`
- `NEXUS_REGISTRY=192.168.94.90:8085`

## Files

- `.gitlab-ci.yml` — deployment, diagnostics, healthcheck, smoke test, and rollback pipeline.
- `DevOps_Troubleshooting_Deployment_Session_92_Commands_CheatSheet.txt` — commands used in the lesson with beginner-friendly English explanations.

## Diagnostic Flow

```text
Runner
  ↓
Network
  ↓
SSH
  ↓
Authentication
  ↓
Docker
  ↓
Port
  ↓
Container
  ↓
Application
  ↓
Environment
  ↓
Healthcheck
  ↓
Smoke Test
```

## Main Diagnostic Commands

```bash
ssh -vvv deploy@192.168.94.91
sudo ss -lntp | grep ':8088'
docker ps -a
docker logs --tail 100 cicd-app
docker inspect cicd-app
curl -i http://127.0.0.1:8088/health
curl -i http://127.0.0.1:8088/
```

## Important Lab Note

The failure scenarios are intentional. Restore the correct SSH permissions, host key, private key, port availability, environment variables, application state, health endpoint, and smoke-test endpoint after each scenario before moving to the next one.
