# Session 27 — Pipeline Variables

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD variables, variable scope, predefined variables, secret handling, and variable precedence.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`
- **DEV-2:** `192.168.94.91`

## Learning Goals

- Define global variables in `.gitlab-ci.yml`.
- Define job-level variables and understand scope.
- Use GitLab predefined variables.
- Understand project CI/CD variables.
- Keep secrets out of the repository.
- Verify a secret exists without printing it.
- Understand the difference between regular variables and file variables.
- Understand the practical variable-precedence model used in the lesson.

## Pipeline Structure

The included `.gitlab-ci.yml` defines three stages:

```text
inspect
   |
   v
build
   |
   v
deploy
```

The jobs are:

- `inspect_variables`
- `job_scope_demo`
- `secret_check`
- `build_metadata`
- `deploy_preview`

All jobs use the `dev-shell` Runner tag.

## Global Variables

The pipeline defines these non-sensitive values in YAML:

```yaml
variables:
  APP_NAME: "cicd-session27-app"
  APP_ENV: "lab"
  DEPLOY_HOST: "192.168.94.91"
  DEPLOY_PORT: "8088"
```

## Job-Level Scope Demo

The `job_scope_demo` job overrides the global `APP_ENV` value only for that job:

```yaml
variables:
  APP_ENV: "job-specific"
```

## Predefined Variables

The lab reads GitLab predefined variables including:

- `CI_PROJECT_NAME`
- `CI_COMMIT_BRANCH`
- `CI_COMMIT_SHORT_SHA`
- `CI_PIPELINE_ID`

The branch variable uses a Bash fallback:

```bash
${CI_COMMIT_BRANCH:-not-a-branch-pipeline}
```

## Secret Variable

Before running the pipeline, create a project CI/CD variable in GitLab:

```text
Key: LAB_SECRET
Type: Variable
Environment scope: All
Visibility: Masked
Protect variable: Off for this lab
```

Do not commit the secret value to the repository.

The pipeline verifies only that the variable exists:

```bash
test -n "$LAB_SECRET"
```

It intentionally does not print the secret.

## Build Metadata

The lab demonstrates how predefined variables can be used to form an image-style version:

```text
APP_NAME + CI_COMMIT_SHORT_SHA
```

Example:

```text
cicd-session27-app:8f371b29
```

## Files

- `.gitlab-ci.yml` — Session 27 pipeline-variable lab.
- `DevOps_Pipeline_Variables_Session_27_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
