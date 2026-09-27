# Session 78 — Container Scanning with Trivy

This lab adds Trivy container vulnerability scanning as a security gate before pushing a Docker image to the registry.

## Topics

- Docker image scanning
- OS package vulnerabilities
- Application dependency vulnerabilities
- Severity levels
- HIGH
- CRITICAL
- Exit codes
- Failing the pipeline

## Lab Flow

```text
Docker Build
     |
     v
Trivy Scan
     |
     +--> HIGH / CRITICAL found --> Pipeline FAIL
     |
     +--> Pass
            |
            v
       Nexus Registry
```

## Lab Environment

### DEV-1 — 192.168.94.90

- GitLab CE
- GitLab Runner
- Docker
- Trivy
- Nexus

The GitLab Runner uses the `dev-shell` tag and the Shell executor.

## Required GitLab CI/CD Variables

Create these variables in GitLab before running the push stage:

```text
NEXUS_REGISTRY
NEXUS_USERNAME
NEXUS_PASSWORD
```

## Pipeline Stages

```text
build
  |
  v
security
  |
  v
push
```

The image is built with the commit short SHA as its tag.

```text
cicd-app:$CI_COMMIT_SHORT_SHA
```

## Security Gate

The first Trivy command creates a JSON report without failing the job:

```bash
trivy image --cache-dir "$TRIVY_CACHE_DIR" --format json --output trivy-report.json --exit-code 0 "$IMAGE_NAME:$IMAGE_TAG"
```

The second Trivy command enforces the security policy:

```bash
trivy image --cache-dir "$TRIVY_CACHE_DIR" --severity HIGH,CRITICAL --exit-code 1 "$IMAGE_NAME:$IMAGE_TAG"
```

If a HIGH or CRITICAL vulnerability is found, Trivy returns exit code `1`, the GitLab job fails, and the image is not pushed to Nexus.

## Trivy Report

The JSON report is stored as a GitLab artifact:

```text
trivy-report.json
```

It is uploaded even when the security job fails and expires after 7 days.

## Main Principle

```text
Docker Build
     |
     v
Trivy Scan
     |
     v
Security Gate
  /       \
FAIL      PASS
            |
            v
         Registry
```

A vulnerability scan becomes a real DevSecOps control when its result can stop the pipeline.
