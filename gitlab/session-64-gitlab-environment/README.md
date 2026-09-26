# Session 64 — GitLab Environments

Chapter 8: Deployment

This lab demonstrates how GitLab Environments track real deployments to development and production while the actual deployment is performed over SSH with Docker.

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
development -> myapp-development -> 192.168.94.91:8088
production  -> myapp-production  -> 192.168.94.91:8089
```

## Pipeline Flow

Development:

```text
develop branch
  -> GitLab Pipeline
  -> dev-shell Runner
  -> pull image from Nexus
  -> SSH to DEV-2
  -> replace myapp-development
  -> publish on port 8088
  -> GitLab tracks the development deployment
```

Production:

```text
default branch
  -> GitLab Pipeline
  -> manual production job
  -> pull the same commit-tagged image
  -> SSH to DEV-2
  -> replace myapp-production
  -> publish on port 8089
  -> GitLab tracks the production deployment
```

## Environment Concepts Demonstrated

- Static environments: `development` and `production`
- Environment URL with `environment:url`
- Deployment tier with `deployment_tier`
- Deployment history in GitLab
- Environment-scoped CI/CD variables
- Automatic development deployment
- Manual production deployment
- Separate container names and ports for environment isolation

## Required GitLab CI/CD Variables

Create the same variable key with different Environment Scopes:

```text
Key: DEPLOY_PORT
Value: 8088
Environment scope: development
```

```text
Key: DEPLOY_PORT
Value: 8089
Environment scope: production
```

The Shell Runner must also already be able to SSH to:

```text
deploy@192.168.94.91
```

Do not commit SSH private keys, passwords, or production secrets to this repository.

## Image Source

The lab expects the application image to already exist in Nexus:

```text
192.168.94.90:8085/myapp:<CI_COMMIT_SHORT_SHA>
```

The deployment stage promotes and runs the existing image; it does not rebuild it.

## Development Deployment

The `deploy_development` job runs for:

```text
develop
```

It creates or replaces:

```text
myapp-development
```

and publishes:

```text
8088:5000
```

## Production Deployment

The `deploy_production` job is available on the default branch and uses:

```yaml
when: manual
```

It creates or replaces:

```text
myapp-production
```

and publishes:

```text
8089:5000
```

## Verification on DEV-2

Check running containers:

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}'
```

Check listening ports:

```bash
sudo ss -lntp | grep -E ':8088|:8089' || true
```

Check development:

```bash
curl -fsS http://192.168.94.91:8088/health
```

Check production:

```bash
curl -fsS http://192.168.94.91:8089/health
```

If the application does not expose `/health`, use its real endpoint instead.

## GitLab Verification

After successful deployments, inspect:

```text
Project -> Operate -> Environments
```

Verify that GitLab shows separate deployment history for:

```text
development
production
```

## Main Principle

```text
script      = performs the real deployment
environment = tells GitLab where that deployment belongs
```

A GitLab Environment is deployment metadata and tracking. It does not create the server, open the port, or run the container by itself.
