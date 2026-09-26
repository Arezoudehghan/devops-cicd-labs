# Session 62 — Nexus Docker Registry in Pipeline

Chapter 7: Docker Build in GitLab CI/CD

This lab connects GitLab CI/CD to a Nexus Docker Hosted Repository. The pipeline builds a Docker image, tags it with both the commit SHA and branch/ref slug, logs in to Nexus securely, pushes both tags, and verifies the result by pulling the commit-tagged image back from the registry.

## Lab Architecture

```text
GitLab
   ↓
GitLab Runner (Shell Executor)
   ↓
Docker Build
   ↓
Nexus Docker Hosted Registry
   ↓
Docker Pull / Verify
```

### DEV-1

- IP: `192.168.94.90`
- GitLab CE
- GitLab Runner
- Docker Engine
- Nexus Repository
- Nexus Docker Hosted connector: `192.168.94.90:8085`

### DEV-2

- IP: `192.168.94.91`
- Docker deployment host
- Used for manual registry pull verification

## Files

- `.gitlab-ci.yml` — Build, tag, login, push, logout, pull, and inspect pipeline.
- `daemon.json.example` — Lab-only Docker daemon example for the HTTP Nexus registry.
- `DevOps_Nexus_Docker_Registry_Session_62_Commands_CheatSheet.txt` — Commands used in this session with beginner-friendly English explanations.

## Required GitLab CI/CD Variables

Create these values in **Project → Settings → CI/CD → Variables**:

- `NEXUS_USERNAME`
- `NEXUS_PASSWORD`

Keep the password masked. Use protected variables only when the target branch/tag is also protected and should receive those secrets.

`NEXUS_REGISTRY` is defined in `.gitlab-ci.yml` as:

```text
192.168.94.90:8085
```

## Nexus Requirements

The lab expects a Nexus repository with these characteristics:

- Repository type: Docker Hosted
- Registry connector port: `8085`
- Docker Bearer Token Realm enabled
- A dedicated CI user with permissions required to read and publish images

The Nexus web UI port and Docker Registry connector are different endpoints. The Docker client must use `192.168.94.90:8085` for this lab.

## HTTP Registry Lab Configuration

The session uses an HTTP registry in the lab. Review the current Docker daemon configuration before changing it and merge the `insecure-registries` setting instead of overwriting unrelated settings.

Example configuration is provided in `daemon.json.example`.

Validate the Docker configuration before restarting Docker:

```bash
sudo dockerd --validate --config-file=/etc/docker/daemon.json
```

Production registries should use trusted TLS rather than an insecure HTTP registry.

## Pipeline Flow

```text
publish_image
   ↓
Docker login
   ↓
Docker build
   ↓
Commit SHA tag
   ↓
Branch/ref tag
   ↓
Push both tags to Nexus
   ↓
verify_pull
   ↓
Pull commit SHA tag
   ↓
Inspect RepoTags
```

The commit-based image tag provides traceability and makes rollback to a known build practical.

## Runner Tag

The jobs in this lab target the Shell Runner tag:

```text
dev-shell
```

The Runner host must have Docker access and network access to `192.168.94.90:8085`.
