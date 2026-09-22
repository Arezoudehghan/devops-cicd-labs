# Session 22 — Runner Security and Shell Executor Risks

Chapter 3 — GitLab Runner

This lab demonstrates the security implications of GitLab Runner when the **Shell executor** is used.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Docker
- Nexus
- Runner tag: `dev-shell`
- Executor: `shell`

## Learning Goals

- Understand why Shell Executor has weak isolation.
- Identify which Linux user runs a GitLab CI job.
- Inspect Runner access to the host operating system.
- Check whether the Runner user belongs to the `docker` group.
- Verify Docker daemon access from the Runner account.
- Inspect sudo permissions for `gitlab-runner`.
- Understand why Docker group membership should be treated as root-level capability.
- Understand the security role of Protected Runner, Protected Branch, Protected Variables, tags, project scope, and code review.

## Runner Security Model

With the Shell executor, commands from `.gitlab-ci.yml` execute directly on the Runner host under the permissions of the Runner user.

```text
Developer
   |
   v
.gitlab-ci.yml
   |
   v
GitLab Pipeline
   |
   v
GitLab Runner
   |
   v
Shell Executor
   |
   v
gitlab-runner user
   |
   +----> Host files
   +----> Processes
   +----> Network
   +----> Docker
   +----> CI/CD variables
```

## Host-side Checks

Check registered runners:

```bash
sudo gitlab-runner list
```

Check the service:

```bash
sudo systemctl status gitlab-runner --no-pager
```

Check the configured executor:

```bash
sudo grep -nE 'name|executor|shell' /etc/gitlab-runner/config.toml
```

Check the Runner account:

```bash
id gitlab-runner
```

Test Docker access as the Runner user:

```bash
sudo -u gitlab-runner -H docker info
```

Inspect sudo permissions:

```bash
sudo -u gitlab-runner -H sudo -n -l
```

Inspect Runner build directories:

```bash
sudo -u gitlab-runner -H find /home/gitlab-runner/builds -maxdepth 5 -type d -print 2>/dev/null | head -n 50
```

## CI Security Check

The included `.gitlab-ci.yml` performs a safe inspection of the Runner environment:

- Runner identity
- Hostname and kernel information
- Working directory
- HOME
- Group membership
- Docker daemon access

The job is routed to the Shell Runner using:

```yaml
tags:
  - dev-shell
```

## Security Findings to Understand

### Shell Executor Isolation

Shell jobs run directly on the Runner host. Anything readable or executable by `gitlab-runner` may also be accessible to the CI job.

### Docker Group

If `gitlab-runner` belongs to the `docker` group, the account has access to the Docker daemon. This must be treated as a high-privilege capability.

### CI/CD Variables

Masked variables are still available to jobs that receive them. Sensitive variables should also be Protected and restricted to trusted pipeline paths.

### Pipeline Configuration

A user who can modify `.gitlab-ci.yml` can influence which commands execute on the Runner infrastructure. Pipeline changes should therefore be reviewed like security-sensitive code.

## Recommended Hardening

- Use Shell Runner only for trusted projects and trusted code.
- Disable **Run untagged jobs** when the Runner is intended for tagged jobs only.
- Use the `dev-shell` tag explicitly.
- Mark sensitive runners as **Protected**.
- Prefer a dedicated **Project Runner** for sensitive workloads.
- Lock the Project Runner to the intended project when appropriate.
- Protect the `main` branch.
- Protect sensitive CI/CD variables.
- Use Masked/Hidden visibility where supported and appropriate.
- Avoid unrestricted `NOPASSWD: ALL` sudo access.
- Treat Docker daemon access as highly privileged.
- Keep critical services separated from Runner infrastructure in production.
- Configure a reasonable maximum job timeout.
- Protect Runner authentication tokens and `/etc/gitlab-runner/config.toml`.

## Main Security Model

```text
Who can modify .gitlab-ci.yml?
            |
            v
What Runner can execute it?
            |
            v
What permissions does that Runner have?
            |
            v
What secrets and systems can it reach?
```

## Files

- `.gitlab-ci.yml` — Runner security inspection pipeline.
- `DevOps_Runner_Security_Session_22_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
