# Session 71 — Rollback

Chapter 8: Deployment

This lab demonstrates manual and automatic rollback for a Docker application deployed from GitLab CI/CD to DEV-2.

## Topics

- Rollback
- Previous Version
- Immutable Image Tag
- Manual Rollback
- Automatic Rollback
- Failure Detection
- Previous-version state
- Production health verification

## Lab Architecture

- DEV-1 — `192.168.10.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus Registry on port `8085`
- DEV-2 — `192.168.10.91`
  - Docker deployment server

Production target:

```text
GitLab Pipeline
  -> dev-shell Runner
  -> resource_group: production
  -> SSH to DEV-2
  -> deploy immutable image
  -> healthcheck
       |-- OK   -> record new stable version
       `-- FAIL -> restore previous stable image
```

## Rollback Scenario

```text
Deploy v2
   |
   v
Healthcheck Fail
   |
   v
Rollback
   |
   v
Deploy v1
```

The important behavior is:

```text
Failed new release + successful rollback

Production = Healthy
Pipeline   = Failed
```

The pipeline stays failed because the new release did not succeed, even when production is restored successfully.

## Version State

DEV-2 stores deployment state under:

```text
/opt/myapp/current_version
/opt/myapp/previous_version
```

A new version becomes the current stable version only after its healthcheck succeeds.

Example:

```text
current_version  = v2
previous_version = v1
```

## Immutable Image Tags

The deployment uses the full Git commit SHA:

```text
192.168.10.90:8085/myapp:<CI_COMMIT_SHA>
```

Do not rely on `latest` as the only production rollback reference because it is mutable.

## Files

- `.gitlab-ci.yml` — production deployment and manual rollback jobs.
- `scripts/deploy-with-rollback.sh` — deploys a new image, verifies health, and automatically restores the previous stable image on failure.
- `scripts/manual-rollback.sh` — manually restores the saved previous version and verifies it.
- `DevOps_Rollback_Session_71_Commands_CheatSheet.txt` — command cheat sheet for this lesson.

## Prepare DEV-2

Create the deployment state directory:

```bash
sudo mkdir -p /opt/myapp
sudo chown -R deploy:deploy /opt/myapp
```

## Required GitLab CI/CD Variables

The pipeline expects these File Type variables:

```text
SSH_PRIVATE_KEY
SSH_KNOWN_HOSTS
```

The Shell Runner must already be able to SSH to:

```text
deploy@192.168.10.91
```

Do not commit SSH private keys, passwords, or registry secrets to the repository.

## Automatic Rollback

The deployment job sends `scripts/deploy-with-rollback.sh` to DEV-2 over SSH.

The script:

```text
Read current stable version
        |
        v
Pull new immutable image
        |
        v
Start new container
        |
        v
Healthcheck
   |            |
   OK          FAIL
   |            |
   v            v
Record       Restore current
new stable   stable version
version           |
                  v
             Healthcheck
```

If rollback succeeds, the script exits with status `1` so GitLab correctly records the failed release.

## Simulate Failure

For the lab, start a pipeline with:

```text
SIMULATE_HEALTH_FAILURE=true
```

The new version is started, its healthcheck is intentionally treated as failed, and the previous stable version is restored.

## Verify Production

On DEV-2:

```bash
cat /opt/myapp/current_version
docker ps
curl -i http://127.0.0.1:8088/health
```

## Manual Rollback

The `rollback_production` job is manual.

Use it when the deployment originally passed its healthcheck but a problem is discovered later, such as a business or application error.

Both deployment and rollback jobs use:

```yaml
resource_group: production
```

This prevents deploy and rollback operations from changing the same production resource at the same time.

## Troubleshooting

Check the recorded stable version:

```bash
cat /opt/myapp/current_version
```

Check local images:

```bash
docker images
```

Check all containers:

```bash
docker ps -a
```

Check application logs:

```bash
docker logs myapp
```

Check the health endpoint:

```bash
curl -v http://127.0.0.1:8088/health
```

Check whether port `8088` is listening:

```bash
ss -lntp | grep 8088
```

## Main Principle

```text
Immutable image
      +
Known previous stable version
      +
Failure detection
      +
Verified restore
      =
Reliable rollback
```
