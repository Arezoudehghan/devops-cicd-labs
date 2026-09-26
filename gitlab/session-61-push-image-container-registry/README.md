# Session 61 — Push Docker Image to Container Registry

This lab demonstrates how to build a Docker image in GitLab CI/CD, authenticate to an external container registry, push an immutable image tag, and clean up Docker credentials.

## Pipeline flow

```text
Git push
  -> GitLab Runner
  -> Docker build
  -> Image inspect
  -> Registry login
  -> Docker push
  -> Registry logout
  -> Credential cleanup
```

## Required GitLab CI/CD variables

Configure these variables in **GitLab > Project > Settings > CI/CD > Variables**:

- `REGISTRY_URL` — registry host and optional port
- `REGISTRY_USER` — registry username
- `REGISTRY_PASSWORD` — registry password or token

Keep `REGISTRY_PASSWORD` masked/hidden and protected when appropriate.

## Image naming

The pipeline creates an immutable image tag using the Git commit:

```text
$REGISTRY_URL/session61-registry-demo:$CI_COMMIT_SHORT_SHA
```

## Credential isolation

The job sets:

```text
DOCKER_CONFIG=$CI_PROJECT_DIR/.docker
```

This keeps Docker client credentials inside the current job workspace instead of the shared Shell Runner home directory.

## Files

- `.gitlab-ci.yml` — build, verify, authenticate, push, logout, and cleanup workflow
- `Dockerfile` — minimal Nginx image
- `index.html` — demo application content
- `DevOps_Container_Registry_Push_Session_61_Commands_CheatSheet.txt` — commands from the lesson with beginner-friendly English explanations
