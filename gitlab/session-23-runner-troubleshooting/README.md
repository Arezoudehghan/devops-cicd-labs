# Session 23 — GitLab Runner Troubleshooting

Chapter 3 — GitLab Runner

This lab focuses on systematic troubleshooting of common GitLab Runner problems: pending jobs, stuck jobs, offline runners, tag mismatch, Linux permission errors, and Docker socket permission issues.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Docker
- Nexus
- Runner tag: `dev-shell`
- Executor: `shell`

## Learning Goals

- Distinguish a normal `pending` job from a job that is effectively stuck.
- Troubleshoot Runner service, registration, connectivity, tags, scope, and capacity.
- Verify Runner connectivity with `gitlab-runner verify`.
- Inspect Runner logs with `journalctl`.
- Understand how Runner tags affect job scheduling.
- Diagnose Linux filesystem permission errors as the `gitlab-runner` user.
- Diagnose Docker daemon and Docker socket permission errors.
- Use a repeatable troubleshooting decision tree instead of trial and error.

## Runner Troubleshooting Flow

```text
Job created
   |
   v
Runner available?
   |
   v
Runner online?
   |
   v
Tags match?
   |
   v
Runner receives job?
   |
   v
Executor starts?
   |
   v
Linux permissions OK?
   |
   v
Docker permissions OK?
```

## Core Runner Checks

Check the GitLab Runner service:

```bash
sudo systemctl status gitlab-runner --no-pager
```

List locally configured runners:

```bash
sudo gitlab-runner list
```

Verify Runner connectivity to GitLab:

```bash
sudo gitlab-runner verify
```

Inspect recent Runner logs:

```bash
sudo journalctl -u gitlab-runner -n 200 --no-pager
```

Follow Runner logs live:

```bash
sudo journalctl -u gitlab-runner -f
```

Validate Runner configuration:

```bash
sudo gitlab-runner lint --config /etc/gitlab-runner/config.toml
```

## Pending and Stuck Jobs

A `pending` job is waiting in the GitLab queue for an eligible Runner.

When a job stays pending unexpectedly, check:

- Runner service status
- Runner registration
- Runner connectivity
- Runner project assignment
- Pause state
- Protected Runner restrictions
- Runner tags
- `Run untagged jobs`
- Runner concurrency and available capacity

## Tag Mismatch

The Runner used in this lab has the tag:

```text
dev-shell
```

A job that should run on this Runner should request that tag:

```yaml
tags:
  - dev-shell
```

A Runner must contain every tag requested by the job.

## Permission Troubleshooting

Shell Executor jobs run under the permissions of the Runner account, typically `gitlab-runner`.

Inspect the Runner user:

```bash
id gitlab-runner
```

Test a command as the Runner user:

```bash
sudo -u gitlab-runner -H whoami
```

When a file command fails in CI, reproduce it as the Runner user instead of testing only as root.

Useful path-permission inspection:

```bash
namei -l /opt/runner-permission-lab/test.txt
```

## Docker Socket Troubleshooting

Check Docker service status:

```bash
sudo systemctl status docker --no-pager
```

Test Docker access as the Runner account:

```bash
sudo -u gitlab-runner -H docker info
```

Inspect the Docker socket:

```bash
ls -l /var/run/docker.sock
```

Inspect Docker group membership:

```bash
getent group docker
id gitlab-runner
```

If the trusted lab Runner requires Docker access, add it to the Docker group:

```bash
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner
```

Then verify:

```bash
sudo -u gitlab-runner -H docker ps
```

Docker group membership is highly privileged and should be limited to trusted Runner hosts and trusted projects.

## Diagnostic Pipeline

The included `.gitlab-ci.yml` runs a small diagnostic job on the `dev-shell` Runner and prints:

- Effective user
- User and group IDs
- Hostname
- Working directory
- Docker information
- Running Docker containers

This helps separate Runner-selection problems from execution and permission problems.

## Troubleshooting Decision Tree

```text
Job pending?
|
+-- Yes
|   |
|   +-- Runner service running?
|   +-- Runner registered?
|   +-- Runner can reach GitLab?
|   +-- Runner paused?
|   +-- Tags match?
|   +-- Runner assigned to project?
|   +-- Capacity available?
|
+-- No, job started
    |
    +-- Permission denied?
    |   +-- Reproduce command as gitlab-runner
    |
    +-- Docker error?
        +-- Check Docker daemon
        +-- Check /var/run/docker.sock
        +-- Check docker group membership
```

## Files

- `.gitlab-ci.yml` — Runner troubleshooting diagnostic pipeline.
- `DevOps_GitLab_Runner_Troubleshooting_Session_23_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
