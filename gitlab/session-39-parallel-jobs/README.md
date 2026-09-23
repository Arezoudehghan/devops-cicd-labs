# Session 39 — Parallel Jobs

This lab demonstrates parallel job execution in GitLab CI/CD and the Runner capacity required to make same-stage jobs run concurrently.

## Topics

- Same-stage job parallelism
- GitLab Runner `concurrent`
- Per-runner `limit`
- `parallel: N`
- `CI_NODE_INDEX` and `CI_NODE_TOTAL`
- `parallel:matrix`
- DAG pipelines with `needs`
- Pending jobs when Runner capacity is exhausted
- Shell Executor resource conflicts
- Unique container names, ports, and temporary files for parallel jobs

## Main Lab Pipeline

```text
build_app
    |
    +----------------+----------------+
    |                |                |
    v                v                v
unit_test         lint_test      security_test
    |                |                |
    +----------------+----------------+
                     |
                     v
                 package_app
```

The three jobs in the `test` stage are independent and can run at the same time when enough Runner capacity is available.

## Lab Environment

- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Main lab host: DEV-1
- Runner configuration: `/etc/gitlab-runner/config.toml`
- Recommended lab concurrency: `concurrent = 3`

## Runner Capacity Check

```bash
sudo grep -E 'concurrent|limit|executor|name' /etc/gitlab-runner/config.toml
```

If `concurrent = 1`, the jobs can be ready in parallel but will effectively execute one at a time on that Runner Manager.

## Parallel Keyword

```yaml
test_app:
  stage: test
  tags:
    - dev-shell
  parallel: 3
  script:
    - echo "Node Index = $CI_NODE_INDEX"
    - echo "Node Total = $CI_NODE_TOTAL"
```

`parallel: 3` creates three instances of the same job. Workload sharding still has to be handled by the test framework or job script.

## DAG with needs

`needs` allows a job to start as soon as its direct dependency finishes instead of waiting for every job in the previous stage.

## Shell Executor Note

Parallel Shell Executor jobs share the same host resources, Docker daemon, ports, filesystem, CPU, RAM, disk, and network. Use job-specific names such as `test-app-$CI_JOB_ID` and job-specific temporary files to avoid collisions.
