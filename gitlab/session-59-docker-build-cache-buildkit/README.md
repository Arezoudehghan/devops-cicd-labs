# Session 59 — Docker Build Cache and BuildKit

Chapter 7: Docker Build in GitLab CI/CD

This lab demonstrates Docker layer caching, Cache Hit/Cache Miss behavior, BuildKit cache mounts, dependency-layer optimization, and faster GitLab CI/CD builds.

## Main Topics

- Docker Layer Cache
- Cache Hit
- Cache Miss
- BuildKit
- Build Cache
- Dependency Layer Optimization
- Pipeline build-time reduction
- `.dockerignore`
- BuildKit cache mounts

## Lab Architecture

```text
Git Push
  -> GitLab Pipeline
  -> Shell Runner on DEV-1
  -> Host Docker Daemon
  -> BuildKit
  -> Local Docker Build Cache
```

DEV-1 uses the existing Shell Runner tag:

```text
dev-shell
```

Because builds use the same Docker daemon on DEV-1, local build cache can be reused between pipelines until the cache is removed or a different builder/runner is used.

## Cache-Friendly Dockerfile Order

```text
Base Image
  -> Working Directory
  -> Dependency Manifest
  -> Install Dependencies
  -> Application Source
```

The important rule is:

```text
Stable things first -> Frequently changing things last
```

## BuildKit Cache Mount

The Dockerfile uses a persistent BuildKit cache mount for pip:

```dockerfile
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install \
    --disable-pip-version-check \
    -r requirements.txt
```

If the dependency layer must be rebuilt, previously downloaded pip packages can still be reused from the cache mount.

## Pipeline

The GitLab pipeline enables BuildKit explicitly and builds two local tags:

- Commit-specific tag: `$CI_COMMIT_SHORT_SHA`
- Moving local tag: `latest`

Build logs use:

```text
--progress=plain
```

so `CACHED` steps are easy to identify.

## Cache Test Flow

1. Run the first build.
2. Run the same build again and observe Cache Hits.
3. Change only `app.py` and rebuild.
4. Change `requirements.txt` and rebuild.
5. Compare which layers are reused and which layers are rebuilt.

## Main Principle

```text
Dependency unchanged
  -> Dependency layer stays cached
  -> Only changed application layers rebuild
  -> Pipeline becomes faster
```
