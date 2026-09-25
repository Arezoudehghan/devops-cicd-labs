# Session 41 — GitLab CI/CD DAG Pipeline

This lab demonstrates how to design a GitLab CI/CD pipeline as a Directed Acyclic Graph (DAG) by defining only the real dependencies between jobs with `needs`.

## Topics

- Stage-based pipelines versus DAG pipelines
- Directed Acyclic Graph concepts
- Direct job dependencies with `needs`
- Independent jobs with `needs: []`
- Runner concurrency versus DAG scheduling
- Artifact transfer with `needs:artifacts`
- `artifacts: true` and `artifacts: false`
- Difference between `needs` and `dependencies`
- Fan-out, fan-in, and diamond dependency patterns
- Optional dependencies with `needs:optional`
- Critical path analysis
- DAG troubleshooting and optimization

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- GitLab Runner configuration: `/etc/gitlab-runner/config.toml`
- Lab repository name used in the lesson: `session41-dag-lab`

## Pipeline Graph

```text
build_frontend ---> test_frontend ---> deploy_frontend ----+
                                                            |
build_backend ----> test_backend ----> deploy_backend -------+--> release_report
                                                            |
lint -------------------------------------------------------+
                                                            |
security_scan ----------------------------------------------+
```

The `lint` and `security_scan` jobs use `needs: []`, so they can start immediately without waiting for the build stage.

## Artifact Flow

`build_frontend` creates `frontend-build.txt`, which is downloaded by `test_frontend`.

`build_backend` creates `backend-build.txt`, which is downloaded by `test_backend`.

The deploy jobs receive their corresponding test artifacts, and `release_report` waits for both deploy paths plus `lint` and `security_scan`.

## Critical Path

The backend path is the longest dependency chain in this lab:

```text
build_backend -> test_backend -> deploy_backend -> release_report
```

The DAG reduces unnecessary waiting by allowing independent paths to progress as soon as their own dependencies are complete.

## Runner Capacity

DAG scheduling makes jobs eligible to run earlier, but actual parallel execution still depends on GitLab Runner capacity.

The lesson checks the global `concurrent` setting in:

```text
/etc/gitlab-runner/config.toml
```

## Files

- `.gitlab-ci.yml` — final Session 41 DAG pipeline
- `DevOps_DAG_Pipeline_Session_41_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
