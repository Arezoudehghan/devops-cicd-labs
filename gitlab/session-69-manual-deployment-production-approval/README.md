# Session 69 — Manual Deployment and Production Approval

Chapter 8: Deployment

This lab demonstrates a production-safe GitLab CI/CD flow where staging deploys automatically, staging is verified with a smoke test, and production waits behind a blocking manual gate.

## Lab Architecture

- DEV-1 — `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus Registry on port `8085`
- DEV-2 — `192.168.94.91`
  - Docker deployment server

Deployment targets:

```text
staging    -> <project>-staging    -> 192.168.94.91:8089
production -> <project>-production -> 192.168.94.91:8088
```

## Pipeline Flow

```text
Default branch
  -> deploy_staging
  -> smoke_test_staging
  -> blocking manual production gate
  -> deploy_production
  -> smoke_test_production
```

## Concepts Demonstrated

- Manual GitLab CI/CD jobs with `when: manual`
- Blocking production deployment with `allow_failure: false`
- Automatic staging deployment
- Manual production deployment
- `manual_confirmation` for an additional human confirmation
- `resource_group: production` to serialize production deployments
- GitLab Environments and deployment tiers
- Staging and production smoke tests
- Default-branch-only production deployment
- Immutable commit-based image reference
- Production safety with protected branches and protected variables
- Difference between a manual job, protected environment, and deployment approval

## Required GitLab CI/CD Variables

The pipeline expects these variables to exist in GitLab:

```text
NEXUS_REGISTRY
SSH_PRIVATE_KEY
SSH_KNOWN_HOSTS
```

Recommended Nexus value for this lab:

```text
192.168.94.90:8085
```

`SSH_PRIVATE_KEY` and `SSH_KNOWN_HOSTS` are expected to be File Type variables because the pipeline passes them directly to SSH with `-i` and `UserKnownHostsFile`.

Do not commit private keys, passwords, registry credentials, or production secrets to this repository.

## Image Reference

The lab deploys the image created for the current commit:

```text
$NEXUS_REGISTRY/$CI_PROJECT_NAME:$CI_COMMIT_SHORT_SHA
```

The deployment stage promotes and runs the existing image. It does not rebuild the application image.

## Staging Deployment

The staging job runs automatically on the default branch.

It creates or replaces:

```text
<project>-staging
```

and publishes:

```text
8089:5000
```

The next job checks:

```text
http://192.168.94.91:8089/health
```

## Production Gate

The production job is available only on the default branch and is blocking:

```yaml
when: manual
allow_failure: false
```

It also uses:

```yaml
manual_confirmation: "Deploy this version to production?"
resource_group: production
```

This means production waits for an explicit human action and concurrent production deployments are serialized.

## Production Deployment

After the manual gate is approved and run, the pipeline creates or replaces:

```text
<project>-production
```

and publishes:

```text
8088:5000
```

The final job checks:

```text
http://192.168.94.91:8088/health
```

## Verification on DEV-2

Check running containers:

```bash
docker ps
```

Check staging:

```bash
curl -i http://192.168.94.91:8089/health
```

Check production:

```bash
curl -i http://192.168.94.91:8088/health
```

## GitLab Edition Note

`when: manual` is available in GitLab Free.

Protected Environments and Deployment Approvals require GitLab Premium or Ultimate. In a GitLab CE/Free lab, use a protected default branch, protected CI/CD variables, restricted project permissions, a blocking manual production job, `manual_confirmation`, and `resource_group` as the practical safety pattern.

## Main Principle

```text
Manual Job           = a human must start the job
Protected Environment = controls who may deploy
Deployment Approval   = requires approval before deployment
```

These mechanisms are related, but they are not the same control.
