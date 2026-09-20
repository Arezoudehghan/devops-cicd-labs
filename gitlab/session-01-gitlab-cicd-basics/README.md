# Session 01 — GitLab CI/CD Basics

This lab introduces the core GitLab CI/CD concepts used throughout the course.

## Topics

- CI, Continuous Delivery, and Continuous Deployment
- Pipeline, Stage, Job, and Runner
- Shell Executor
- Predefined CI/CD variables
- Artifacts
- CI Lint and Pipeline Editor validation
- Basic GitLab Runner troubleshooting

## Lab Architecture

### DEV-1
- IP: `192.168.94.90`
- GitLab CE
- GitLab Runner
- Shell Executor
- Runner tag: `dev-shell`
- Docker
- Nexus

### DEV-2
- IP: `192.168.94.91`
- Docker deployment server
- Monitoring services used in later sessions

## Files

- `app.sh` — simple Bash application used by the pipeline.
- `.gitlab-ci.yml` — Validate → Test → Package pipeline.
- `DevOps_GitLab_CICD_Pipeline_Session_01_Commands_CheatSheet.txt` — command cheat sheet from this lesson.

## Pipeline Flow

```text
Git Push
   |
   v
GitLab
   |
   v
GitLab Runner (dev-shell)
   |
   +--> validate_script
   |
   +--> test_script
   |
   +--> package_script
             |
             v
          Artifact
```

## Predefined Variables Practiced

- `CI_PROJECT_NAME`
- `CI_COMMIT_BRANCH`
- `CI_COMMIT_SHORT_SHA`
- `CI_PIPELINE_ID`

## Validation

Before pushing pipeline changes, validate `.gitlab-ci.yml` with GitLab Pipeline Editor / CI Lint.
