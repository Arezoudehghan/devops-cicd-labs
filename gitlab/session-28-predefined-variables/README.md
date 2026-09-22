# Session 28 — GitLab Predefined Variables

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD predefined variables and how branch, tag, commit, pipeline, and Runner workspace context are exposed to jobs.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`
- **DEV-2:** not required for this session

## Learning Goals

- Understand GitLab predefined variables.
- Inspect the full and short commit SHA.
- Distinguish branch pipelines from tag pipelines.
- Understand the difference between a commit identifier and a pipeline identifier.
- Use `CI_PROJECT_DIR` instead of hard-coding the Runner workspace path.
- Use predefined variables safely in `rules`.
- Understand why job-only variables cannot be used for pipeline-creation decisions.

## Variables Covered

- `CI_COMMIT_SHA` — full commit SHA.
- `CI_COMMIT_SHORT_SHA` — first 8 characters of the commit SHA.
- `CI_COMMIT_BRANCH` — branch name in branch pipelines.
- `CI_COMMIT_TAG` — tag name in tag pipelines.
- `CI_PIPELINE_ID` — unique pipeline ID in the GitLab instance.
- `CI_PROJECT_DIR` — project working directory on the Runner.

## Pipeline Jobs

The included `.gitlab-ci.yml` contains three jobs:

- `show-predefined-variables`
- `branch-only-job`
- `tag-only-job`

All jobs use the `dev-shell` Runner tag.

## Branch Pipeline Behavior

For a normal push to `main`:

```text
CI_COMMIT_BRANCH=main
CI_COMMIT_TAG=
```

The `branch-only-job` job is included because this rule evaluates true:

```yaml
rules:
  - if: '$CI_COMMIT_BRANCH'
```

## Tag Pipeline Behavior

For a tag such as `v1.0.0`:

```text
CI_COMMIT_BRANCH=
CI_COMMIT_TAG=v1.0.0
```

The `tag-only-job` job is included because this rule evaluates true:

```yaml
rules:
  - if: '$CI_COMMIT_TAG'
```

## Commit vs Pipeline

The same commit can produce more than one pipeline.

Example:

```text
Commit abc12345
  |
  +-- Branch pipeline -> CI_PIPELINE_ID=100
  |
  +-- Tag pipeline    -> CI_PIPELINE_ID=101
```

The commit SHA can stay the same while the pipeline ID changes.

## Runner Workspace

Use:

```bash
cd "$CI_PROJECT_DIR"
```

instead of hard-coding a path such as:

```text
/home/gitlab-runner/builds/...
```

This keeps the pipeline portable across Runner configurations.

## Important Availability Note

`CI_COMMIT_SHA`, `CI_COMMIT_SHORT_SHA`, `CI_COMMIT_BRANCH`, and `CI_COMMIT_TAG` are available early enough for pipeline/ref logic.

`CI_PIPELINE_ID` and `CI_PROJECT_DIR` are job-only variables. Do not depend on job-only variables in `rules`, `workflow`, or `include` decisions.

## Files

- `.gitlab-ci.yml` — Session 28 predefined-variable lab.
- `DevOps_Predefined_Variables_Session_28_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
