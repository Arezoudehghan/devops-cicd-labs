# Session 25 — Job and Stage

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD jobs and stages: how stages define pipeline flow and how jobs define executable units of work.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

Deployment preview target:

- **DEV-2:** `192.168.94.91`

## Learning Goals

- Understand the difference between `stages` and `stage`.
- Understand a GitLab CI/CD Job as an executable unit of work.
- Define multiple stages in a pipeline.
- Assign jobs to stages.
- Understand that jobs in the same stage can run in parallel when Runner capacity is available.
- Understand normal stage-gating behavior when a job fails.
- Understand the default `test` stage when a job has no explicit `stage`.
- Practice naming jobs clearly.
- Troubleshoot undefined stages, indentation problems, and Runner tag mismatches.

## Pipeline Flow

The lab pipeline contains four stages:

```text
validate
   |
   v
build
   |
   v
test
   |
   +-- syntax_test
   +-- health_test
   |
   v
deploy
```

The five jobs are:

- `validate_app`
- `build_app`
- `syntax_test`
- `health_test`
- `deploy_preview`

## Job and Stage Model

A useful mental model is:

```text
Stage  = Pipeline flow / order
Job    = Unit of work
script = Commands
Runner = Worker
```

The global `stages` keyword defines the stage order:

```yaml
stages:
  - validate
  - build
  - test
  - deploy
```

A job uses the singular `stage` keyword to select its stage:

```yaml
validate_app:
  stage: validate
  script:
    - bash -n app.sh
```

## Lab Application

The included `app.sh` script prints:

```text
Application status: healthy
```

The validation and syntax-test jobs check Bash syntax with:

```bash
bash -n app.sh
```

The health-test job verifies the application output with:

```bash
./app.sh | grep -q "healthy"
```

## Pipeline Behavior

Normal successful flow:

```text
validate_app
     |
     v
build_app
     |
     v
+------------------+
| syntax_test      |
| health_test      |
+------------------+
     |
     v
deploy_preview
```

The two test jobs are in the same stage. They can run concurrently when Runner capacity allows it.

If `health_test` is intentionally changed to search for `unhealthy`, that job fails and the normal `deploy` stage is blocked.

## Important Notes

- `stages` defines the ordered list of pipeline stages.
- `stage` assigns one job to one stage.
- A stage by itself does not execute commands; jobs do.
- A job without an explicit `stage` uses the default `test` stage.
- A job that references a stage not present in the configured stage list causes a configuration problem.
- Job names should be unique and descriptive.
- Files created by one job are not automatically transferred to another independent job; artifacts are used for that purpose in later lessons.
- All jobs in this lab use the `dev-shell` Runner tag.

## Troubleshooting

### Undefined stage

If a job uses:

```yaml
stage: deploy
```

then `deploy` must exist in the configured stage list.

### Wrong keyword

Inside a job, use:

```yaml
stage: build
```

not:

```yaml
stages: build
```

### Runner tag mismatch

This lab expects:

```yaml
tags:
  - dev-shell
```

A mismatched tag can leave a job pending.

### YAML indentation

Job properties such as `stage`, `tags`, and `script` must remain correctly indented under the job name.

## Files

- `.gitlab-ci.yml` — Session 25 pipeline with validate, build, test, and deploy stages.
- `app.sh` — Simple application script used by validation, build, and health-test jobs.
- `DevOps_Job_and_Stage_Session_25_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
