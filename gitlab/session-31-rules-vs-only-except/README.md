# Session 31 — rules vs only/except

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab compares modern GitLab CI/CD `rules` with the legacy `only` and `except` keywords. It focuses on first-match behavior, branch and Merge Request conditions, `when: never`, and safe migration from older pipeline syntax.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

DEV-2 is not required for this session because the lab focuses on pipeline job-selection logic.

## Learning Goals

- Understand what `only` and `except` do in legacy pipelines.
- Understand why `rules` is preferred for new GitLab CI/CD configuration.
- Understand top-to-bottom evaluation and first-match behavior.
- Use `when: never` to exclude a job.
- Use `CI_COMMIT_BRANCH`, `CI_COMMIT_TAG`, and `CI_PIPELINE_SOURCE` in rules.
- Translate common `only/except` patterns into `rules`.
- Keep legacy examples separate from the modern pipeline instead of mixing both styles in the same job.

## Main Pipeline

The included `.gitlab-ci.yml` uses only `rules`.

Behavior:

- Push to a feature branch → `test`.
- Merge Request pipeline → `test`.
- Push to `main` → `test`, `build`, and manual `deploy`.
- Other conditions that do not match a job's rules → that job is not added to the pipeline.

The deploy rule is:

```yaml
rules:
  - if: '$CI_COMMIT_BRANCH == "main" && $CI_PIPELINE_SOURCE == "push"'
    when: manual
```

## Legacy Comparison Examples

The `examples/` directory contains separate pipeline examples so legacy syntax is not mixed into the main pipeline:

- `only-main.yml` — job runs only on `main`.
- `except-main.yml` — job runs on branches except `main`.
- `rules-equivalent.yml` — modern `rules` equivalent of the `except: main` behavior.

## First Match Rule

GitLab evaluates job rules from top to bottom. The first matching rule decides the job behavior, so specific rules should normally be placed before general rules.

Example:

```yaml
rules:
  - if: '$CI_COMMIT_BRANCH == "main"'
    when: manual

  - if: '$CI_COMMIT_BRANCH'
    when: on_success
```

On `main`, the first rule matches and the second rule is not used.

## Files

- `.gitlab-ci.yml` — Modern Session 31 pipeline using `rules`.
- `examples/only-main.yml` — Legacy `only` example.
- `examples/except-main.yml` — Legacy `except` example.
- `examples/rules-equivalent.yml` — Modern equivalent using `rules` and `when: never`.
- `DevOps_Rules_vs_Only_Except_Session_31_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
