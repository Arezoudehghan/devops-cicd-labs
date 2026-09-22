# Session 29 — GitLab CI/CD Rules

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD `rules` and how jobs are included in a pipeline based on branch, tag, pipeline source, changed files, and existing files.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

## Learning Goals

- Understand how GitLab evaluates `rules` from top to bottom.
- Apply the first-match-wins behavior correctly.
- Run jobs only for branch pipelines, Merge Request pipelines, or tags.
- Use `CI_PIPELINE_SOURCE`, `CI_COMMIT_BRANCH`, `CI_COMMIT_TAG`, and `CI_DEFAULT_BRANCH`.
- Use `rules:changes` for file-change based execution.
- Use `rules:exists` for repository-file detection.
- Configure a manual production deployment.
- Match release tags with a regular expression.
- Understand the difference between job-level `rules` and `workflow: rules`.

## Pipeline Structure

The included `.gitlab-ci.yml` defines five stages:

```text
verify
  |
  v
test
  |
  v
build
  |
  v
deploy
  |
  v
release
```

The jobs are:

- `branch-check`
- `mr-test`
- `docs-check`
- `docker-check`
- `build-main`
- `deploy-production`
- `release`

All jobs use the `dev-shell` Runner tag.

## Rules Scenarios

### Branch push

`branch-check` runs when the pipeline source is `push` and `CI_COMMIT_BRANCH` exists.

### Merge Request

`mr-test` runs when:

```text
CI_PIPELINE_SOURCE=merge_request_event
```

### Documentation changes

`docs-check` requires both a Merge Request pipeline and a change under:

```text
docs/**/*
```

### Dockerfile detection

`docker-check` is included when `Dockerfile` exists in the repository.

### Default branch build

`build-main` runs when:

```text
CI_COMMIT_BRANCH == CI_DEFAULT_BRANCH
```

### Manual production deployment

`deploy-production` is available only on the default branch and uses:

```yaml
when: manual
allow_failure: false
```

### Release tag

`release` matches semantic-style tags such as:

```text
v1.0.0
v1.2.3
```

## Files

- `.gitlab-ci.yml` — Session 29 rules pipeline.
- `Dockerfile` — Minimal file used by the `rules:exists` lab.
- `app/app.sh` — Simple executable application script used by CI jobs.
- `docs/README.md` — Documentation file used by the `rules:changes` lab.
- `DevOps_Rules_Session_29_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
