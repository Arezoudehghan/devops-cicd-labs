# Session 49 — Quality Gate: Lint + Unit Test + Fail Pipeline

This lab builds a simple GitLab CI/CD quality gate that blocks the build when linting or unit tests fail.

## Topics

- Quality Gate
- Lint with Ruff
- Unit testing with pytest
- Exit codes
- Job failure behavior
- Preventing build after test failure
- `allow_failure`
- GitLab Job Log troubleshooting

## Lab Environment

- GitLab Runner executor: Shell
- Runner tag: `dev-shell`

## Pipeline Flow

```text
Git Push
   |
   v
Lint
   |
   v
Unit Test
   |
   v
Build
```

The build stage runs only when both quality gates pass.

## Project Files

- `.gitlab-ci.yml` — GitLab pipeline with lint, test, and build stages
- `app.py` — small Python application used by the lab
- `requirements-dev.txt` — Ruff and pytest development dependencies
- `tests/test_app.py` — unit tests for the Python functions
- `DevOps_Quality_Gate_Session_49_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
