# Session 40 — GitLab CI/CD `needs`

This lab demonstrates how GitLab CI/CD `needs` creates direct job dependencies and allows a pipeline to run as a DAG instead of waiting for every job in the previous stage.

## Topics

- Default stage-by-stage execution
- Direct job dependencies with `needs`
- DAG pipeline execution
- `needs: []` for jobs with no execution dependency
- Multiple dependencies for a single job
- Artifact transfer with `needs:artifacts`
- `artifacts: true` and `artifacts: false`
- Difference between `needs` and `dependencies`
- Optional dependencies with `needs:optional`
- Runner capacity and the global `concurrent` setting
- Troubleshooting pipelines that do not run in parallel

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- GitLab Runner configuration: `/etc/gitlab-runner/config.toml`
- Lab repository name used in the lesson: `needs-lab`

## Pipeline Graph

```text
build_api --------> test_api -----------------+
                                               |
build_frontend ---> test_frontend ------------+--> deploy
                                               |
lint ------------------------------------------+
```

The `lint` job uses `needs: []`, so it has no execution dependency on the build jobs.

## Artifact Flow

`build_api` creates `output/api.txt`, and `test_api` downloads it through:

```yaml
needs:
  - job: build_api
    artifacts: true
```

`build_frontend` creates `output/frontend.txt`, and `test_frontend` receives it in the same way.

The final `deploy` job waits for `test_api`, `test_frontend`, and `lint`, but it does not download artifacts from those jobs.

## Runner Capacity

`needs` makes jobs eligible to start earlier, but actual parallel execution still depends on Runner capacity.

The lesson checks:

```text
concurrent = 2
```

and also verifies that a runner-specific `limit` is not restricting concurrency.

## Files

- `.gitlab-ci.yml` — final Session 40 DAG pipeline
- `DevOps_Needs_Session_40_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
