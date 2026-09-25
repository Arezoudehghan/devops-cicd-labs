# Session 42 — GitLab CI/CD Artifact

This lab demonstrates how GitLab CI/CD job artifacts preserve build output and make it available to later jobs.

## Topics

- Artifact concept and lifecycle
- `artifacts:paths`
- `artifacts:name`
- `artifacts:expire_in`
- Artifact upload from the build job
- Automatic artifact download in a later stage
- Verification with `test -f`
- Artifact versus cache
- Artifact versus container registry
- Troubleshooting missing artifact files

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Pipeline file: `.gitlab-ci.yml`

## Pipeline Flow

```text
build_package
    |
    | creates build/application.txt
    | uploads build/ as an artifact
    v
GitLab Artifact Storage
    |
    | downloads artifact for next stage
    v
verify_package
    |
    v
test -f build/application.txt
```

## Artifact Configuration

```yaml
artifacts:
  name: "${CI_PROJECT_NAME}-${CI_COMMIT_SHORT_SHA}"
  paths:
    - build/
  expire_in: 1 day
```

## Verification

The `verify_package` job checks that `build/application.txt` exists and prints its content. This proves that the file produced by `build_package` was preserved as an artifact and restored for the later job.

## Files

- `.gitlab-ci.yml` — Session 42 artifact pipeline
- `.gitignore` — excludes generated `build/` output from Git
- `DevOps_Artifact_Session_42_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations
