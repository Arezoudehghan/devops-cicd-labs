# Session 56 — Build Docker Image Inside GitLab Pipeline

Chapter 7: Docker Build in GitLab CI/CD

This lab demonstrates how to build a Docker image directly inside a GitLab CI/CD pipeline by using an existing Shell Runner on DEV-1.

## Main Topics

- `docker build`
- Docker image name and image tag
- GitLab predefined CI/CD variables
- Build context
- Docker build arguments
- Proxy settings during Docker build
- Image verification after build

## Pipeline Flow

```text
GitLab Runner
      ↓
docker build
      ↓
Application Image
      ↓
Image Verification
```

## Runner

The pipeline targets the existing Shell Runner tag:

```text
dev-shell
```

Because this lab uses a Shell Executor, Docker commands run directly against the Docker Engine on the Runner host.

## Image Naming

The pipeline creates the image reference from GitLab predefined variables:

```text
CI_PROJECT_PATH_SLUG
        +
CI_COMMIT_SHORT_SHA
        ↓
project-name:commit-sha
```

This provides direct traceability between the Docker image and the Git commit that created it.

## Build Arguments

The pipeline passes the following build-time values:

- `APP_VERSION=$CI_COMMIT_SHORT_SHA`
- `HTTP_PROXY=$HTTP_PROXY`
- `HTTPS_PROXY=$HTTPS_PROXY`
- `NO_PROXY=$NO_PROXY`

Proxy values should be configured as GitLab CI/CD variables instead of being hard-coded in the Dockerfile.

## Build Context

The final dot in:

```bash
docker build ... .
```

means the current directory is used as the Docker build context.

The Dockerfile can only copy files that are available inside that context and are not excluded by `.dockerignore`.

## Verification

After the build, the pipeline verifies that the image exists:

```bash
docker image inspect "$IMAGE" > /dev/null
docker image ls "$IMAGE_NAME"
```

## Lab Architecture

### DEV-1

```text
192.168.10.90
GitLab CE
GitLab Runner
Docker
Nexus
```

The Docker image created by this lesson initially exists only on the Docker Engine of DEV-1.

## Main Principle

```text
Git Commit
   ↓
GitLab Pipeline
   ↓
docker build
   ↓
Commit-tagged Docker Image
   ↓
Verification
```

A later registry stage can push the built image to Nexus so that another host such as DEV-2 can pull and deploy it.
