# Session 68 — Healthcheck and Smoke Test

This lab adds deployment verification to the GitLab CI/CD flow by checking Docker container health and running application smoke tests after deployment.

## Topics

- Docker HEALTHCHECK
- Application `/health` endpoint
- `curl` HTTP checks
- HTTP status validation
- Retry loops
- Connection and request timeouts
- Internal healthcheck
- External smoke test
- Deployment success/failure verification

## Lab Environment

- DEV-1: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Nexus Docker Registry: `192.168.94.90:8085`
- DEV-2: `192.168.94.91`
- Application published port: `8088`
- Application container port: `5000`

## Pipeline Flow

```text
Deploy
  ↓
Healthcheck
  ↓
Smoke Test
  ↓
Success / Failure
```

The healthcheck runs on DEV-2 against `localhost:8088/health` with retry and timeout handling. The smoke test runs from the GitLab Runner on DEV-1 against DEV-2 so it also verifies network reachability and the published port.

## Project Files

- `.gitlab-ci.yml` — deploy, retrying healthcheck, and external smoke-test jobs
- `Dockerfile` — Flask image with Docker HEALTHCHECK
- `app.py` — example application with `/` and `/health` endpoints
- `requirements.txt` — minimal Flask dependency for the example application
- `compose.yaml` — application deployment and Compose healthcheck definition
- `scripts/healthcheck.sh` — retrying application healthcheck script
- `scripts/smoke-test.sh` — main endpoint and health endpoint smoke tests
- `DevOps_Healthcheck_Smoke_Test_Session_68_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations

## Compose Variable

The Compose example uses `${APP_VERSION}` in the image tag, matching the lesson example. Supply that variable in the deployment environment before running Compose.
