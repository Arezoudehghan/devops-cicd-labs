# Session 20 — Shell, Docker, and Kubernetes Executors

This lab compares the three GitLab Runner execution models covered in this lesson:

- Shell Executor — runs CI jobs directly on the Runner host.
- Docker Executor — runs each CI job inside a Docker container.
- Kubernetes Executor — runs each CI job inside a Kubernetes Pod.

## Learning goals

By the end of this lab you should be able to explain:

- where a job actually runs for each executor;
- how dependency management differs between host-based and image-based execution;
- why Docker and Kubernetes provide cleaner job environments;
- why executor isolation depends on configuration, not only the executor name;
- when Shell, Docker, or Kubernetes is a reasonable design choice;
- why Docker Executor does not automatically mean that `docker build` can access a Docker daemon.

## Lab environment

### DEV-1

IP: `192.168.94.90`

Services used in the course lab:

- GitLab CE
- GitLab Runner
- Docker
- Nexus
- CI/CD tools

### DEV-2

IP: `192.168.94.91`

DEV-2 is the deployment/monitoring target used by the wider course. It is not required for the basic executor-comparison pipeline in this session.

## Execution model

### Shell Executor

```text
GitLab
  |
  v
GitLab Runner
  |
  v
Shell / Bash
  |
  v
Runner Host
```

The job uses software installed on the Runner host and shares the host filesystem within the permissions of the Runner user.

### Docker Executor

```text
GitLab
  |
  v
GitLab Runner
  |
  v
Docker Engine
  |
  v
Job Container
```

The job environment is defined by a container image such as `alpine:3.20` or `python:3.12`.

### Kubernetes Executor

```text
GitLab
  |
  v
GitLab Runner
  |
  v
Kubernetes API
  |
  v
Pod
```

The Runner asks Kubernetes to create a Pod for the CI job. Scheduling, RBAC, namespaces, resource requests/limits, service accounts, and cluster policy become part of the Runner design.

## Practical pipeline

The default `.gitlab-ci.yml` contains two jobs:

- `shell_executor_test`
- `docker_executor_test`

Both jobs print basic execution-environment information and create a temporary file.

The Shell job writes:

```text
/tmp/shell-${CI_PIPELINE_ID}.txt
```

The Docker job writes:

```text
/tmp/docker-${CI_PIPELINE_ID}.txt
```

After the pipeline finishes, the Shell file should exist on the Runner host because the Shell job ran directly there. The Docker file was created inside the job container and normally does not exist on the Runner host after that container is removed.

## Required Runner tags

The lesson pipeline expects:

```text
dev-shell
dev-docker
```

If your registered Runner tags are different, update the `tags:` values before running the pipeline.

The Kubernetes example expects:

```text
dev-k8s
```

and is stored separately in `kubernetes-executor-example.yml` so it does not affect the normal Shell/Docker lab.

## Docker build note

Docker Executor controls where the CI job executes. It does not automatically provide access to a Docker daemon.

A job that runs `docker build` still needs a supported Docker build architecture, for example:

- host Docker access in a controlled Shell Runner;
- Docker-in-Docker;
- Docker socket binding;
- another image-building approach suitable for the environment.

Treat privileged mode and Docker socket access as security-sensitive configuration.

## Security summary

Shell Executor has direct host exposure because job commands execute on the Runner host with the Runner user's permissions.

Docker Executor provides container isolation, but that isolation can be weakened by privileged mode, sensitive host mounts, or Docker socket access.

Kubernetes Executor provides Pod-based isolation and scheduling, but security depends on RBAC, Pod security controls, service accounts, namespaces, host mounts, networking, and cluster policy.

## Files

- `.gitlab-ci.yml` — executable Shell vs Docker comparison pipeline.
- `kubernetes-executor-example.yml` — Kubernetes Executor CI example from the lesson.
- `DevOps_GitLab_Runner_Executors_Session_20_Commands_CheatSheet.txt` — commands used in Session 20 with beginner-friendly English explanations.

## Key memory model

```text
Shell       -> Job runs on the host
Docker      -> Job runs in a container
Kubernetes  -> Job runs in a Pod
```

Choose the simplest executor that safely satisfies the workload, isolation, dependency, scale, and infrastructure requirements.
