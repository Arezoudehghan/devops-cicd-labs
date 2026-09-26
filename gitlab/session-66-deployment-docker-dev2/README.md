# Session 66 — Docker Deployment on DEV-2

Chapter 8: Deployment

This lab demonstrates deploying a Docker image from Nexus to DEV-2 through GitLab CI/CD and SSH.

## Lab Architecture

```text
DEV-1 (192.168.94.90)
GitLab + GitLab Runner + Nexus
        |
        | SSH
        v
DEV-2 (192.168.94.91)
Docker Deployment
```

## Deployment Flow

```text
Pull new image
  -> Stop old container
  -> Remove old container
  -> Run new container
  -> Verify container
```

The new image is pulled before the running container is stopped. This reduces the risk of downtime when the new image cannot be downloaded.

## Main Values Used in the Lab

- Nexus Registry: `192.168.94.90:8085`
- Deploy Host: `192.168.94.91`
- Deploy User: `deploy`
- Runner Tag: `dev-shell`
- Host Port: `8088`
- Container Port: `5000`
- Image Tag: `$CI_COMMIT_SHORT_SHA`

## Deployment Behavior

The pipeline connects to DEV-2 by SSH, pulls the exact commit-tagged image, replaces the previous container, starts the new container with `--restart unless-stopped`, and verifies that the container is running.

DEV-2 must already have Docker access for the `deploy` user and must be able to pull from the Nexus registry. If the registry is private, authenticate Docker on DEV-2 before deployment.

## Environment Variables

The container receives:

- `APP_ENV=production`
- `APP_VERSION=$CI_COMMIT_SHORT_SHA`

## Rollback Principle

Because images use commit-based tags, a previous image can be started again when a new deployment is unhealthy.

## Files

- `.gitlab-ci.yml` — SSH-based Docker deployment job for DEV-2
- `DevOps_Deployment_Docker_DEV2_Session_66_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations
