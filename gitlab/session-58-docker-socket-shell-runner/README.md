# Session 58 — Docker Socket in Shell Runner

Chapter 7: Docker Build in GitLab CI/CD

This lab demonstrates how a GitLab Shell Runner on DEV-1 uses the host Docker daemon through the Docker Unix socket.

## Main Topics

- `/var/run/docker.sock`
- Docker CLI and Docker daemon communication
- Runner access to Docker
- `docker` group membership
- Linux permissions
- Docker socket security risk
- Practical Docker build on DEV-1

## Lab Architecture

```text
GitLab Pipeline
  -> Shell Runner
  -> gitlab-runner user
  -> Docker CLI
  -> /var/run/docker.sock
  -> Docker daemon (dockerd)
  -> Docker image build
```

## Runner Host

DEV-1 uses the Shell Runner tag:

```text
dev-shell
```

The job runs as the `gitlab-runner` user and uses the Docker daemon installed on the host.

## Docker Socket Verification

```bash
ls -l /var/run/docker.sock
stat -c '%A %a %U %G %n' /var/run/docker.sock
id gitlab-runner
sudo -u gitlab-runner -H docker info
```

## Docker Group Access

To allow the Shell Runner to access the host Docker daemon:

```bash
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner
```

Verify the access:

```bash
sudo -u gitlab-runner -H docker version
sudo -u gitlab-runner -H docker info
sudo -u gitlab-runner -H docker ps
```

## Pipeline Build

The included `.gitlab-ci.yml`:

1. Confirms the job user and group membership.
2. Verifies Docker client/daemon communication.
3. Builds an image tagged with `CI_PROJECT_NAME` and `CI_COMMIT_SHORT_SHA`.
4. Inspects the image.
5. Lists the built image.

The build command is:

```bash
docker build -t "${CI_PROJECT_NAME}:${CI_COMMIT_SHORT_SHA}" .
```

A valid `Dockerfile` must exist in the build context when this job is used in an actual GitLab project.

## Security Principle

Access to the Docker socket is highly privileged. A runner that can control the rootful Docker daemon must be treated as a trusted runner and should execute only trusted CI/CD jobs.

Do not solve Docker socket permission problems by opening the socket to all users with `chmod 666` or `chmod 777`.

## Rollback

Remove the runner from the Docker group:

```bash
sudo gpasswd -d gitlab-runner docker
sudo systemctl restart gitlab-runner
```

## Main Principle

```text
Shell Runner -> Docker CLI -> Docker Socket -> Host Docker Daemon
```
