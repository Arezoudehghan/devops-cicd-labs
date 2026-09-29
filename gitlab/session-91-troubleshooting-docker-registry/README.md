# Session 91 — Troubleshooting Docker and Registry

Chapter 11 — Troubleshooting and Performance

This lab focuses on diagnosing Docker and private-registry failures from GitLab CI/CD job logs.

## Lab environment

- DEV-1: `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Docker Engine
  - Nexus access
- Nexus Docker Registry: `192.168.94.90:8085`
- DEV-2: `192.168.94.91`
  - Docker deployment target
- Runner tag: `dev-shell`
- Runner executor: Shell

## Main troubleshooting scenarios

- Docker build failure
- Docker daemon permission errors
- Docker daemon unavailable
- Certificate and TLS errors
- Authentication errors
- `401 Unauthorized`
- Registry authorization and push failures
- Image tag errors
- Missing local image tags
- Disk full
- Inode exhaustion

## Troubleshooting flow

```text
Pipeline Failed
      ↓
Job Log
      ↓
Find the real error
      ↓
Identify the failing layer
      ↓
Reproduce outside the pipeline
      ↓
Fix
      ↓
Run the pipeline again
```

## Reference pipeline

The root `.gitlab-ci.yml` contains the corrected reference pipeline from this lesson:

1. Build the image with the private-registry image name.
2. Tag it with `$CI_COMMIT_SHORT_SHA`.
3. Authenticate with `--password-stdin`.
4. Push the image to `192.168.94.90:8085`.
5. Log out from the registry.

Required GitLab CI/CD variables:

- `REGISTRY_USER`
- `REGISTRY_PASSWORD`

## Key diagnostic mapping

- `Dockerfile not found` → build context/path
- `permission denied ... docker.sock` → Runner user / Docker socket permissions
- `Cannot connect to the Docker daemon` → Docker service/socket
- `x509: certificate signed by unknown authority` → certificate trust chain
- `401 Unauthorized` → authentication
- `403 Forbidden` / requested access denied → authorization or repository permission
- `invalid reference format` → image name/tag
- `image does not exist locally` → missing local tag
- `no space left on device` → disk usage or inode exhaustion

## Files

```text
session-91-troubleshooting-docker-registry/
├── .gitlab-ci.yml
├── README.md
└── DevOps_Troubleshooting_Docker_Registry_Session_91_Commands_CheatSheet.txt
```
