# Session 04 — Shift Left and Fail Fast

This lab demonstrates how to move fast, low-cost validation checks earlier in a GitLab CI/CD pipeline and stop the pipeline immediately when a critical gate fails.

## Learning goals

- Understand the difference between **Shift Left** and **Fail Fast**.
- Validate Python syntax before expensive pipeline work.
- Run unit tests before packaging and deployment.
- Run Gitleaks as an early security gate.
- Package and deploy only when all earlier gates pass.
- Deploy the demo application to DEV-2 and verify its health endpoint.

## Lab environment

- **DEV-1:** `192.168.94.90` — GitLab CE, GitLab Runner, CI/CD tools
- **DEV-2:** `192.168.94.91` — deployment target
- **Runner tag:** `dev-shell`
- **Application port:** `18044`

## Pipeline flow

```text
Validate
   ↓
Unit Test
   ↓
Secret Scan
   ↓
Package
   ↓
Deploy
   ↓
Health Check
```

A failure in a critical early stage prevents later stages from running.

## Files

- `.gitlab-ci.yml` — GitLab pipeline with validation, test, security, package, and deploy stages
- `app.py` — simple Python HTTP application
- `tests/test_app.py` — unit test used by the pipeline
- `.gitignore` — ignored Python/cache/archive files
- `DevOps_Shift_Left_Fail_Fast_Session_4_Commands_CheatSheet.txt` — commands used in this lesson with English explanations

## Important GitLab CI/CD variables

The deploy job expects these GitLab **File** variables:

- `SSH_PRIVATE_KEY`
- `SSH_KNOWN_HOSTS`

The lab uses strict host-key checking for SSH deployment.
