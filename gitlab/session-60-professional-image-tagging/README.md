# Session 60 — Professional Docker Image Tagging

Chapter 7: Docker Build in GitLab CI/CD

This lab demonstrates a professional Docker image-tagging strategy in GitLab CI/CD.

## Tagging Strategy

- Full commit SHA: immutable traceability source
- Short commit SHA: readable commit reference
- Branch slug: moving tag for the latest branch build
- Semantic version: immutable release tag such as `v1.3.0`
- `latest`: moving tag for the latest stable release

Example references:

```text
myapp:4f21a6c9
myapp:develop
myapp:v1.3.0
myapp:latest
```

## Pipeline Flow

Branch pipeline:

```text
Build once
  -> full SHA tag
  -> short SHA tag
  -> branch slug tag
  -> push all tags
```

Release tag pipeline:

```text
Pull existing full-SHA image
  -> add semantic-version tag
  -> push release tag
  -> add latest tag
  -> push latest
```

The release job does not rebuild the image. It promotes the already-built commit image.

## Required GitLab CI/CD Variables

Configure these variables in the GitLab project:

- `NEXUS_REGISTRY`
- `NEXUS_USER`
- `NEXUS_PASSWORD`

The pipeline also passes `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY` as Docker build arguments when those variables are available.

## Runner

The pipeline targets the existing Shell Runner tag:

```text
dev-shell
```

## Release Tag Format

The release job runs for semantic release tags matching:

```text
vMAJOR.MINOR.PATCH
```

Examples:

```text
v1.3.0
v1.3.1
v2.0.0
```

## Main Principle

```text
Build Once -> Tag Many -> Promote the Same Image
```

For production deployments, prefer a fixed semantic version, full commit SHA, or image digest instead of relying only on `latest`.
