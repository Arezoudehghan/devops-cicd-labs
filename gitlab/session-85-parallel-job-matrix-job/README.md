# Session 85 — Parallel Job and Matrix Job

This lab demonstrates advanced parallel execution in GitLab CI/CD with `parallel` and `parallel:matrix`.

## Main Scenario

The same Python test suite is executed against three Python versions:

```text
Python 3.11
Python 3.12
Python 3.13
```

GitLab creates one matrix job for each version. When the Runner has enough concurrency, the jobs can run at the same time and reduce total pipeline duration.

## Pipeline

```text
Git Push
   |
   v
+-----------------------+
| Python 3.11 -> pytest |
| Python 3.12 -> pytest |  parallel matrix
| Python 3.13 -> pytest |
+-----------+-----------+
            |
            v
          Build
```

## Lab Environment

- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Docker available on the Runner host
- Python tests execute inside temporary Docker containers

## Files

- `.gitlab-ci.yml` — Python version matrix and build gate
- `app.py` — small sample Python module
- `tests/test_app.py` — pytest test used by every matrix job
- `requirements.txt` — test dependency
- `DevOps_Parallel_Job_Matrix_Job_Session_85_Commands_CheatSheet.txt` — commands cheat sheet

## Key Concepts

- `parallel: N` creates multiple instances of the same job.
- `parallel:matrix` creates job instances with different variable values.
- `CI_NODE_INDEX` and `CI_NODE_TOTAL` identify numeric parallel job instances.
- Matrix jobs are useful for multiple runtime versions and environments.
- Actual simultaneous execution depends on GitLab Runner capacity and concurrency.

## Runner Capacity

If the pipeline creates three matrix jobs but the Runner can execute only one job at a time, the remaining jobs stay pending until capacity becomes available.

Check the Runner configuration at:

```text
/etc/gitlab-runner/config.toml
```

The pipeline configuration in this folder uses Docker from the Shell Runner host to test the project on Python 3.11, 3.12, and 3.13.
