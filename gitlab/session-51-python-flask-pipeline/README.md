# Session 51 — Complete Python and Flask Pipeline

This lab builds a complete GitLab CI/CD pipeline for a Python Flask application using dependency installation, virtual environments, linting, testing, runtime health checking, and build artifacts.

## Topics

- Dependency installation with pip
- `requirements.txt` and `requirements-dev.txt`
- Python virtual environments in CI
- pip dependency cache
- Ruff linting
- pytest unit tests
- JUnit test reports
- Flask application
- Environment variables
- Gunicorn runtime
- Dynamic health-check port
- Build artifact packaging
- SHA-256 checksum generation

## Lab Environment

- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Application: Python + Flask
- WSGI server: Gunicorn

## Pipeline Flow

```text
Install
  |
  v
Lint
  |
  v
Test
  |
  v
Build + Healthcheck
  |
  v
Artifact
```

The build stage runs only after dependency validation, linting, and tests succeed. The build job then starts the release with Gunicorn, verifies the `/health` endpoint, and creates the final archive and SHA-256 checksum.

## Project Files

- `.gitlab-ci.yml` — complete Install → Lint → Test → Build pipeline
- `app.py` — Flask application with `/` and `/health` endpoints
- `requirements.txt` — runtime dependencies
- `requirements-dev.txt` — development dependencies for linting and testing
- `tests/test_app.py` — Flask tests using pytest
- `.gitignore` — ignores virtual environments, caches, test reports, and build output
- `DevOps_Python_Flask_Pipeline_Session_51_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
