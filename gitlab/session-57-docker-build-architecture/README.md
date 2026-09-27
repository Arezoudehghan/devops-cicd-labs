# Session 57 — Docker Build Architecture in CI/CD

Chapter 7: Docker Build in GitLab CI/CD

This lesson compares the main architectures and tools used to build container images in GitLab CI/CD.

## Compared Architectures and Builders

- Shell Runner + Docker Socket
- Docker Executor + Docker Socket
- Docker-in-Docker (DinD)
- BuildKit
- Buildah
- Kaniko

## Comparison Criteria

- Isolation
- Performance
- Security
- Privilege requirements
- Cache behavior
- Production suitability

## Important Architecture Distinction

The following are mainly ways that a CI job gets access to a container build environment:

```text
Shell Runner + Docker Socket
Docker Executor + Docker Socket
Docker-in-Docker
```

The following are container image build engines or build tools:

```text
BuildKit
Buildah
Kaniko
```

These categories can be combined. For example, a Shell Runner can use the host Docker daemon while Docker uses BuildKit as its build engine.

## Current Lab Architecture

```text
GitLab
  -> Shell Runner (dev-shell)
  -> Host Docker Engine
  -> BuildKit
  -> Application Image
  -> Nexus Registry
```

The current lab keeps the existing dedicated Shell Runner architecture because it is simple, fast, and benefits from the host Docker layer cache.

## Security Notes

- Access to `/var/run/docker.sock` gives a CI job very powerful control over the host Docker daemon.
- Docker Executor improves job-environment isolation, but mounting the host Docker socket does not remove the Docker-host security risk.
- Classic Docker-in-Docker normally requires privileged mode.
- Rootless BuildKit and Rootless Buildah can build images without exposing the host Docker socket.
- The original Google Kaniko repository is archived, so new production designs should evaluate maintained alternatives such as Rootless BuildKit.

## Pipeline in This Session

The included `.gitlab-ci.yml` verifies the current Shell Runner build architecture by:

1. Building an image with `docker build`.
2. Tagging it with `CI_COMMIT_SHORT_SHA`.
3. Inspecting the resulting image.

The project that runs this pipeline must contain a valid Dockerfile in its build context.

## Runner

The pipeline targets the existing Shell Runner tag:

```text
dev-shell
```

## Main Mental Model

```text
Executor
  +
Container/Image Builder
  +
Privilege Model
  +
Cache Model
  =
CI Build Architecture
```

For trusted dedicated runners, Shell Runner + Docker + BuildKit can be practical. For shared or less-trusted CI environments, prefer designs that reduce direct access to the host Docker socket and privileged containers.
