# Session 63 — Docker Image Lifecycle and Cleanup

This lab covers Docker image lifecycle management for GitLab CI/CD, with separate retention thinking for Snapshot, Release, and Production images.

## Topics

- Docker image retention
- Cleanup policy design
- Removing old and dangling images
- Preventing Runner and Registry storage exhaustion
- Snapshot image lifecycle
- Release image lifecycle
- Production image protection
- Nexus Cleanup Policy
- Docker unused manifest/image cleanup
- Blob Store compaction

## Lab Environment

- Main host: DEV-1
- DEV-1 IP: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Nexus Docker Registry: `192.168.94.90:8085`

## Pipeline Flow

```text
inspect_storage
      |
      v
cleanup_runner
```

The inspection job checks host disk usage, Docker disk usage, all local images, and dangling images.

The cleanup job runs:

```bash
docker image prune -f
```

This removes dangling images from the local Docker Engine without an interactive confirmation prompt.

## Important Registry Note

Local Docker cleanup and Nexus Registry cleanup are separate operations.

`docker image prune` only cleans the Docker Engine on the Runner host. Nexus Registry lifecycle management is handled through Nexus Cleanup Policies and the related maintenance flow described in this lesson:

```text
Cleanup Policy
      |
      v
Soft Delete
      |
      v
Delete unused manifests/images
      |
      v
Compact Blob Store
      |
      v
Disk space reclaimed
```

## Retention Model

- Snapshot images — short retention
- Release images — longer retention
- Production images — protected and conservative cleanup

A Production image that is still needed for deployment or rollback should not be removed by an aggressive cleanup policy.

## Files

- `.gitlab-ci.yml` — Session 63 Runner storage inspection and dangling-image cleanup pipeline
- `DevOps_Docker_Image_Lifecycle_Cleanup_Session_63_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
