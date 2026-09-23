# Session 34 — Hidden Job and Template Job

This lab demonstrates reusable GitLab CI/CD configuration with hidden jobs and `extends`.

## Topics

- Hidden jobs whose names start with `.`
- Template jobs for reusable CI/CD configuration
- `extends` inheritance
- Multi-level inheritance
- Variable override behavior
- Array replacement behavior
- Shared Runner tags and `before_script`
- Build artifacts passed to later stages
- Deployment rules for the default branch

## Pipeline

```text
build_app
   |
   v
test_app
   |
   v
deploy_app
```

The hidden templates are:

```text
.base_template
.build_template
.test_template
.deploy_template
```

Only the real jobs appear in the pipeline.

## Lab Environment

- GitLab Runner: Shell executor
- Runner tag: `dev-shell`
- Main lab host: DEV-1
- Repository pipeline file: `.gitlab-ci.yml`

## Key Design Pattern

```text
.base_template
      |
      +--> .build_template  --> build_app
      +--> .test_template   --> test_app
      +--> .deploy_template --> deploy_app
```

This structure follows the DRY principle by keeping shared configuration in one place.
