# Session 38 — Stage Execution Order

This lab demonstrates how GitLab CI/CD stages control pipeline execution order and how jobs inside the same stage can run in parallel when Runner capacity is available.

## Topics

- Stage execution order with `stages:`
- Difference between `stages` and `stage`
- Same-stage parallel jobs
- Stage barriers between build, test, and deploy
- Runner concurrency and pending jobs
- Failure gating between stages
- `allow_failure: true`
- `when: always`
- Special `.pre` and `.post` stages
- Preparation for `needs`, dependencies, and artifacts

## Pipeline

```text
prepare
   |
   v
build
   |-- build_backend
   |-- build_frontend
   |
   v
test
   |-- unit_test
   |-- security_test
   |
   v
deploy
```

The next stage waits for the previous stage to complete successfully in a normal stage-based pipeline.

## Lab Environment

- GitLab Runner: Shell executor
- Runner tag: `dev-shell`
- Main lab host: DEV-1
- Runner configuration: `/etc/gitlab-runner/config.toml`
- Repository pipeline file: `.gitlab-ci.yml`

## Key Behavior

```text
build_frontend -----+
                    |
build_backend ------+--> test stage --> deploy stage
```

If one build job finishes early, the test stage still waits for the remaining build jobs. Real parallel execution depends on available Runner capacity.
