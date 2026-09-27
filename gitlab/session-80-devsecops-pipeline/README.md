# Session 80 — Complete DevSecOps Pipeline

This lab combines quality gates, security gates, Docker image delivery, Nexus, and SSH deployment in one GitLab CI/CD pipeline.

## Pipeline

```text
Git Push
   ↓
Lint
   ↓
Unit Test
   ↓
Secret Scan
   ↓
Docker Build
   ↓
Container Scan
   ↓
Push Registry
   ↓
Deploy
```

## Lab Architecture

### DEV-1 — 192.168.10.90

- GitLab CE
- GitLab Runner with tag `dev-shell`
- Docker
- Gitleaks
- Trivy
- Nexus Docker Registry on `192.168.10.90:8085`

### DEV-2 — 192.168.10.91

- Docker deployment host
- SSH user: `deploy`
- Application container published on host port `8088`

## Security Gates

- Flake8 blocks the pipeline on lint errors.
- Pytest blocks the pipeline on failed unit tests.
- Gitleaks blocks the pipeline when a secret is detected.
- Trivy blocks the pipeline when HIGH or CRITICAL findings match the configured policy.
- The image is pushed to Nexus only after the container scan passes.

## Required GitLab CI/CD Variables

- `NEXUS_USERNAME`
- `NEXUS_PASSWORD`
- `SSH_PRIVATE_KEY` as a File variable
- `SSH_KNOWN_HOSTS` as a File variable

## Image Tagging

The pipeline tags each image with `CI_COMMIT_SHORT_SHA`:

```text
192.168.10.90:8085/<project-name>:<short-commit-sha>
```

## Files

- `.gitlab-ci.yml` — complete DevSecOps pipeline
- `app.py` — sample Flask application
- `tests/test_app.py` — unit tests
- `Dockerfile` — application image
- `requirements.txt` — Python runtime dependency
- `DevOps_DevSecOps_Pipeline_Session_80_Commands_CheatSheet.txt` — commands cheat sheet for this lesson
