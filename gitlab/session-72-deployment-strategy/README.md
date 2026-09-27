# Session 72 — Deployment Strategy

Chapter 9: Variables, Secrets and DevSecOps

This lesson compares four deployment strategies:

- Recreate
- Rolling
- Blue-Green
- Canary

The comparison focuses on downtime, risk, resource usage, rollback, VM deployments, and Kubernetes deployments.

## Lab Architecture

- DEV-1 — `192.168.10.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus Registry on port `8085`
- DEV-2 — `192.168.10.91`
  - Docker deployment server
  - Prometheus
  - Grafana
  - Node Exporter
  - cAdvisor

Example application versions:

```text
myapp:v1.0.0
myapp:v2.0.0
```

## Recreate

Recreate stops and removes the old version before starting the new version.

```text
v1 Running
    |
    v
v1 Stop
    |
    v
Downtime
    |
    v
v2 Start
```

Kubernetes example:

```text
kubernetes/recreate-deployment.yaml
```

## Rolling

Rolling deployment gradually replaces old instances with new instances.

```text
v1 v1 v1
v1 v1 v2
v1 v2 v2
v2 v2 v2
```

The Kubernetes example uses `maxUnavailable: 1`, `maxSurge: 1`, and a readiness probe.

See:

```text
kubernetes/rolling-deployment.yaml
```

## Blue-Green

Blue-Green keeps two environments available:

```text
Blue  = v1
Green = v2
```

VM example:

```text
Blue  -> 127.0.0.1:8081
Green -> 127.0.0.1:8082
Nginx -> :8088
```

See:

```text
nginx/blue-green.conf
```

Kubernetes examples:

```text
kubernetes/blue-deployment.yaml
kubernetes/green-deployment.yaml
kubernetes/service-blue.yaml
kubernetes/service-green.yaml
```

The Service selector switches traffic from `version: blue` to `version: green`.

## Canary

Canary gradually shifts traffic to the new version.

```text
95% v1 / 5% v2
80% v1 / 20% v2
50% v1 / 50% v2
0% v1 / 100% v2
```

The VM example uses weighted Nginx upstream servers.

See:

```text
nginx/canary.conf
```

## Rolling vs Canary

```text
Rolling -> Instance replacement
Canary  -> Traffic shifting
```

## Strategy Summary

- Recreate — simple and low resource usage, but downtime is expected.
- Rolling — gradual instance replacement with very low or zero downtime when multiple replicas are available.
- Blue-Green — near-zero downtime and very fast rollback, but higher resource usage.
- Canary — gradual traffic exposure and lower release risk, but needs monitoring and routing control.

## Healthcheck Principle

A running container is not the same as a ready application.

```text
Container Started
      |
      v
Application Initializing
      |
      v
Database / Cache Ready
      |
      v
Application Ready
```

## Rollback

```bash
kubectl rollout history deployment/myapp
kubectl rollout undo deployment/myapp
kubectl rollout status deployment/myapp
```

## Database Compatibility

When v1 and v2 can run at the same time, database changes should remain backward-compatible.

```text
Expand
  |
  v
Migrate
  |
  v
Contract
```

Application rollback does not automatically mean database rollback.

## Command Cheat Sheet

```text
DevOps_Deployment_Strategy_Session_72_Commands_CheatSheet.txt
```
