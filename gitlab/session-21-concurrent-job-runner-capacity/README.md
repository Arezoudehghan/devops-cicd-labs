# Session 21 — Concurrent Job and Runner Capacity

This lab demonstrates how GitLab Runner capacity controls the number of CI jobs that can run at the same time.

## Learning goals

By the end of this lab you should be able to explain:

- the difference between pipeline parallelism and Runner capacity;
- how the global `concurrent` setting limits total Runner Manager capacity;
- how per-runner `limit` restricts one registered Runner;
- why `request_concurrency` is different from job execution concurrency;
- how multiple jobs in the same stage behave with `concurrent = 1`, `2`, and `4`;
- why increasing concurrency without checking CPU, RAM, disk I/O, networking, and shared resources can reduce reliability.

## Lab environment

### DEV-1

IP: `192.168.94.90`

Services used in the course lab:

- GitLab CE
- GitLab Runner
- Docker
- Nexus
- CI/CD tools

The Runner used by this session is the Shell Runner tagged:

`dev-shell`

## Main Runner settings

The GitLab Runner configuration file is:

`/etc/gitlab-runner/config.toml`

The important settings in this session are:

- `concurrent` — global capacity across all registered runners managed by the Runner process;
- `limit` — capacity limit for one specific `[[runners]]` entry;
- `request_concurrency` — number of concurrent requests used to ask GitLab for new jobs, not the number of jobs that can execute.

A conservative lab configuration used in this lesson is:

```toml
concurrent = 2

[[runners]]
  name = "dev-1"
  limit = 2
  executor = "shell"
```

Do not commit a real `config.toml` containing Runner authentication tokens to the repository.

## Practical pipeline

The included `.gitlab-ci.yml` defines four independent jobs in the same stage:

- `job-1`
- `job-2`
- `job-3`
- `job-4`

Each job prints Runner/concurrency variables, records its start time, sleeps for 30 seconds, and records its end time.

The pipeline uses these predefined variables:

- `CI_JOB_NAME`
- `CI_RUNNER_DESCRIPTION`
- `CI_RUNNER_ID`
- `CI_CONCURRENT_ID`
- `CI_CONCURRENT_PROJECT_ID`

## Test matrix

### Test 1

Set:

```toml
concurrent = 1
```

Expected behavior: one job runs while the other three remain pending.

### Test 2

Set:

```toml
concurrent = 2
```

Expected behavior: two jobs run together, followed by the remaining two.

### Test 3

Set:

```toml
concurrent = 4
```

Expected behavior: all four jobs can run together if no other Runner constraint blocks them.

### Test 4

Set:

```toml
concurrent = 4

[[runners]]
  name = "dev-1"
  limit = 2
  executor = "shell"
```

Expected behavior: this Runner still executes at most two jobs concurrently because its per-runner `limit` is lower than the global capacity.

## Monitoring

During the test, monitor DEV-1 with `htop` or `top`.

The lesson also uses:

```bash
ps -u gitlab-runner -o pid,ppid,etime,%cpu,%mem,cmd
```

and:

```bash
watch -n 1 'ps -u gitlab-runner -o pid,ppid,etime,%cpu,%mem,cmd'
```

to observe Runner-owned processes.

## Shell Executor note

With Shell Executor, concurrent jobs run on the same host and can compete for shared resources or conflict over shared files, container names, ports, or deployment targets.

Examples of risky shared resources include:

- one fixed container name;
- one fixed published port;
- one shared deployment directory;
- one production environment.

Runner concurrency should therefore be sized for both host capacity and workload safety.

## Files

- `.gitlab-ci.yml` — four-job concurrency test pipeline.
- `DevOps_Concurrent_Job_Runner_Capacity_Session_21_Commands_CheatSheet.txt` — commands used in Session 21 with beginner-friendly English explanations.

## Key memory model

```text
concurrent          -> Global Runner Manager capacity
limit               -> Per registered Runner capacity
request_concurrency -> Concurrent requests for new jobs
```

Jobs can be ready to run in parallel, but Runner capacity determines how many actually execute at the same time.
