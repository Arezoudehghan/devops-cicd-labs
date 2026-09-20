# Session 03 — Traditional Deployment vs CI/CD

Hands-on lab comparing a fully manual deployment with an automated GitLab CI/CD deployment.

## Lab Architecture

- **DEV-1 — 192.168.94.90:** GitLab CE, GitLab Runner (Shell executor), Docker, Git
- **DEV-2 — 192.168.94.91:** Docker deployment server
- **Application port:** `8083`
- **Image:** `cicd-session3-app`
- **Container:** `cicd-session3-app`

## Deployment Flow

Manual deployment:

`package → scp → ssh → docker build → docker compose up → health check`

CI/CD deployment:

`git push → validate → build → container health test → artifact → SSH deploy → production health check`

## Files

- `Dockerfile` — Nginx image with Docker HEALTHCHECK
- `compose.yaml` — production container definition and `8083:80` mapping
- `.gitlab-ci.yml` — validate, build, artifact, deploy, and health-check pipeline
- `index.html` — final v2 page deployed by CI/CD
- `health.html` — health-check endpoint
- `DevOps_Traditional_Deployment_vs_CICD_Session_3_Commands_CheatSheet.txt` — commands used in this lesson with English explanations

## Required GitLab CI/CD Variables

Create these as **File** variables in the GitLab project:

- `SSH_PRIVATE_KEY_SESSION3`
- `SSH_KNOWN_HOSTS_SESSION3`

No private key, password, token, or known-host value is committed to this repository.
