# Session 87 — Pipeline for Microservices

This lab demonstrates independent GitLab CI/CD pipelines for a multi-repository Microservice architecture.

## Topics

- Multiple repositories
- Multiple services
- Independent pipelines
- Immutable image versioning with `CI_COMMIT_SHORT_SHA`
- Per-service deployment
- Service dependency awareness
- Backward-compatible service contracts
- Independent rollback

## Structure

```text
session-87-microservice-pipeline/
├── auth-service/
│   └── .gitlab-ci.yml
├── order-service/
│   └── .gitlab-ci.yml
├── notification-service/
│   └── .gitlab-ci.yml
├── deployment/
│   ├── compose.yaml
│   └── .env
├── README.md
└── DevOps_Microservice_Pipeline_Session_87_Commands_CheatSheet.txt
```

## Multi-repository mapping

In the real architecture from this lesson, these service directories represent separate GitLab repositories:

```text
auth-service.git
order-service.git
notification-service.git
```

Each service owns its own `.gitlab-ci.yml`, image version, and release cycle.

The pipeline examples assume the real service repository already contains its application source code and a `Dockerfile`.

## Image versioning

Each service image uses the GitLab short commit SHA.

## Deployment model

The deployment Compose file keeps an independent version variable for every service. A single service can then be updated without recreating its dependencies.

## Lab targets

- DEV-1 / Nexus Registry: `192.168.94.90:8085`
- DEV-2 / Docker Deploy Server: `192.168.94.91`
- Runner tag: `dev-shell`

## Topic

Chapter 10 — Advanced Pipelines  
Session 87 — Pipeline for Microservices
