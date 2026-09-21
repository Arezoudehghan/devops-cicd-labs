# Session 19 — Docker Executor

This lab demonstrates how to register and use a GitLab Runner with the Docker executor so CI/CD jobs run inside temporary Docker containers instead of directly on the Runner host.

## Learning goals

- Understand the difference between GitLab Runner and an executor.
- Compare Shell Executor and Docker Executor.
- Register a second Runner on DEV-1 using the Docker executor.
- Use the `docker-executor` Runner tag.
- Use a default Docker image from `config.toml`.
- Override the default image with per-job `image:` values.
- Run supporting service containers with `services:`.
- Verify container isolation with Alpine and Python jobs.
- Test a Redis service container with `redis-cli`.
- Troubleshoot Runner tags, Docker daemon access, image pulls, and CI image requirements.
- Understand why Docker Executor is different from building Docker images inside a CI job.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1
- **Existing Shell Runner tag:** `dev-shell`
- **Docker Runner name:** `dev-1-docker`
- **Docker Runner tag:** `docker-executor`
- **Executor:** `docker`
- **Default image:** `alpine:3.21`
- **GitLab URL:** `http://192.168.94.90/`
- **Runner config:** `/etc/gitlab-runner/config.toml`
- **Privileged mode:** `false`

DEV-2 is not required for this session because the lab focuses on GitLab Runner execution on DEV-1.

## Architecture

```text
GitLab
   |
   v
GitLab Runner Manager on DEV-1
   |
   +-- Shell Runner
   |     tag: dev-shell
   |
   +-- Docker Runner
         tag: docker-executor
         |
         v
      Docker Engine
         |
         +-- Alpine job container
         +-- Python job container
         +-- Redis service container
```

## Runner registration

The Docker Runner is registered against:

```text
http://192.168.94.90/
```

The authentication token is read into the shell variable:

```text
$RUNNER_TOKEN
```

The Runner configuration uses:

```text
Runner name: dev-1-docker
Executor: docker
Default image: alpine:3.21
Pull policy: if-not-present
Tag: docker-executor
```

The real Runner authentication token is not stored in this repository.

## Pipeline lab

The included `.gitlab-ci.yml` contains three stages:

```text
inspect
test
service
```

The jobs are:

- `inspect_container` — runs in `alpine:3.21` and verifies OS, user, hostname, working directory, and GitLab predefined variables.
- `python_test` — runs in `python:3.12-alpine` and verifies that Python comes from the selected job image.
- `redis_service_test` — runs a Redis client in the main job container and connects to a Redis service container through the alias `redis`.

All jobs use the Runner tag:

```text
docker-executor
```

## Expected verification

A successful pipeline should confirm:

- Job logs show `Preparing the "docker" executor`.
- `inspect_container` reports Alpine Linux.
- `python_test` prints the Python version and `Hello from Docker Executor`.
- `redis_service_test` returns `PONG`.

## Important concept

Docker Executor and Docker image building are different concepts.

Docker Executor means the CI job itself runs inside a Docker container. Running `docker build` inside that job additionally requires access to a Docker daemon, for example through Docker-in-Docker, Docker socket binding, or another build method.

This session intentionally keeps:

```toml
privileged = false
```

## Troubleshooting focus

The lesson checks:

- Docker service status.
- Docker access for the `gitlab-runner` user.
- Image pulls as the Runner user.
- Runner registration and verification.
- Runner tag matching.
- Pending or stuck jobs.
- Proxy, certificate, and registry problems during image pulls.
- CI images that lack a usable shell or have an incompatible ENTRYPOINT.

## Lab files

- `.gitlab-ci.yml` — Docker Executor pipeline with Alpine, Python, and Redis jobs.
- `DevOps_Docker_Executor_Session_19_Commands_CheatSheet.txt` — unique executable commands from this lesson with beginner-friendly English explanations.
- `README.md` — lab notes and architecture for Session 19.

## Key idea

GitLab Runner receives the job, the Docker Executor asks Docker Engine to create the required job and service containers, the scripts run inside those containers, and the temporary environment is cleaned up after the job finishes.
