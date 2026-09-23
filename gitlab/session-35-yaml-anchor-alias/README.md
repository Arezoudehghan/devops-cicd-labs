# Session 35 — YAML Anchor and Alias

This lab demonstrates reusable GitLab CI/CD configuration with YAML anchors, aliases, and merge keys.

## Topics

- YAML anchors with `&name`
- YAML aliases with `*name`
- Mapping merge with `<<: *name`
- Hidden jobs as reusable configuration templates
- Shared Runner tags
- Shared `before_script` and `after_script`
- Job-level overrides
- DRY GitLab CI/CD configuration
- Difference between YAML anchors and GitLab `extends`

## Pipeline

```text
build_job
   |
   v
test_job
```

Both jobs reuse configuration from:

```text
.common_job: &common_job
```

The reusable configuration is merged into each real job with:

```yaml
<<: *common_job
```

## Lab Environment

- GitLab Runner: Shell executor
- Runner tag: `dev-shell`
- Main lab host: DEV-1
- Repository pipeline file: `.gitlab-ci.yml`

## Key Design Pattern

```text
.common_job: &common_job
          |
          +--> build_job
          |
          +--> test_job
```

YAML anchors reduce repeated configuration while keeping the real pipeline jobs explicit.
