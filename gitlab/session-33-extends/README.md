# Session 33 — extends

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD `extends`, hidden jobs, reusable job templates, multiple inheritance, configuration merging, and child overrides.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

DEV-2 is not required for this session because deployment is simulated inside the pipeline.

## Learning Goals

- Reuse common GitLab CI/CD configuration with `extends`.
- Build hidden template jobs such as `.base-job` and `.deploy-template`.
- Understand how child jobs override parent values.
- Use more than one parent template in a job.
- Understand that arrays such as `script`, `tags`, and `rules` are replaced rather than concatenated automatically.
- Use inherited variables, `before_script`, and `after_script`.
- Combine `extends`, `needs`, `artifacts`, and `rules` in one practical pipeline.

## Pipeline Structure

The included `.gitlab-ci.yml` defines three stages:

```text
prepare
   |
   v
test
   |
   v
deploy
```

The executable jobs are:

- `prepare-job`
- `test-job`
- `deploy-job`

The hidden templates are:

- `.base-job`
- `.deploy-template`

## Extends Flow

`prepare-job` and `test-job` inherit the common Runner tag, variables, and `before_script` from `.base-job`.

`deploy-job` inherits from both `.base-job` and `.deploy-template`. It overrides `DEPLOY_ENVIRONMENT` from `staging` to `production`.

## Artifact Flow

`prepare-job` creates:

```text
build/info.txt
```

The file is stored as a GitLab artifact. The downstream jobs use `needs` with `artifacts: true` to access it.

## Deployment Rule

The deploy job runs only when:

```yaml
$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

This keeps the deployment simulation limited to the default branch.

## Files

- `.gitlab-ci.yml` — Session 33 pipeline demonstrating `extends`.
- `DevOps_GitLab_CI_Extends_Session_33_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
