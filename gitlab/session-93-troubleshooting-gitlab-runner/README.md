# Session 93 — Troubleshooting GitLab Runner

Chapter 11 — Troubleshooting and Performance

This lab is intentionally scenario-driven and contains broken CI/CD behavior so Runner problems can be diagnosed from evidence instead of trial and error.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Docker
- Runner tag: `dev-shell`
- Executor: `shell`

## Topics

- Pending Job
- Stuck Job
- Runner Offline
- Tag Mismatch
- Timeout
- Retry
- Executor Error
- Runner Log
- Resource Problem

## Main Troubleshooting Flow

```text
Job Status
   |
   v
Runner Status in GitLab
   |
   v
Tag Matching
   |
   v
Runner Service
   |
   v
Runner Verification
   |
   v
Runner Log
   |
   v
Executor
   |
   v
Permissions
   |
   v
CPU / RAM / Disk
   |
   v
Network / GitLab connectivity
```

## Intentionally Broken Pipeline

The included `.gitlab-ci.yml` contains two deliberate failures.

### 1. Tag mismatch

The `diagnose` job requests:

```yaml
tags:
  - wrong-runner
```

The lab Runner uses:

```text
dev-shell
```

This causes the job to remain pending because no eligible Runner matches the requested tag.

To continue the lab, replace `wrong-runner` with `dev-shell`.

### 2. Timeout

The `test` job uses:

```yaml
timeout: 1m
```

but executes:

```bash
sleep 120
```

The job therefore runs longer than its allowed timeout and is terminated.

## Runner Service Checks

```bash
sudo gitlab-runner status
sudo systemctl status gitlab-runner
sudo gitlab-runner list
sudo gitlab-runner verify
```

## Runner Logs

```bash
sudo journalctl -u gitlab-runner
sudo journalctl -u gitlab-runner -n 100
sudo journalctl -u gitlab-runner -f
```

## Resource Checks

```bash
free -h
uptime
top
df -h
df -i
docker system df
docker system df -v
```

## Docker Permission Test

```bash
id gitlab-runner
sudo -u gitlab-runner docker ps
```

This reproduces Docker access using the same account that normally runs Shell Executor jobs.

## Runner Configuration

```bash
sudo cat /etc/gitlab-runner/config.toml
```

Runner capacity is related to settings such as:

```toml
concurrent = 1
```

A pending job does not always indicate a failure. The Runner may simply have no free execution capacity.

## Diagnostic Model

```text
Symptom
   |
   v
Evidence
   |
   v
Hypothesis
   |
   v
Test
   |
   v
Root Cause
   |
   v
Fix
```

## Files

- `.gitlab-ci.yml` — intentionally broken GitLab Runner troubleshooting pipeline.
- `Dockerfile` — minimal build target used by the pipeline.
- `DevOps_Troubleshooting_GitLab_Runner_Session_93_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations.
