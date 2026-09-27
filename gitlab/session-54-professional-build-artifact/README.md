# Session 54 — Professional Build Artifact

This lab demonstrates a production-style GitLab CI/CD artifact workflow: test reporting, versioned build artifacts, metadata, checksum verification, artifact transfer with `needs`, and publishing tagged builds to the GitLab Generic Package Registry.

## Topics

- Build Artifact
- Artifact naming with predefined CI/CD variables
- Artifact paths
- Artifact expiration
- Artifact transfer between jobs
- `needs:artifacts`
- JUnit test reports
- Build metadata
- SHA-256 checksum verification
- Tagged release publishing
- Build Once, Deploy Many

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Pipeline file: `.gitlab-ci.yml`

## Pipeline Flow

```text
test
  |
  | JUnit report
  v
build
  |
  | dist/<project>-<commit>.tar.gz
  | build-meta/build-info.txt
  | build-meta/SHA256SUMS
  v
verify_artifact
  |
  | sha256sum -c
  v
publish_release
  |
  v
GitLab Generic Package Registry
```

## Key Artifact Configuration

```yaml
artifacts:
  name: "${CI_PROJECT_NAME}-${CI_COMMIT_REF_SLUG}-${CI_COMMIT_SHORT_SHA}-${CI_PIPELINE_ID}"
  paths:
    - dist/
    - build-meta/
  expire_in: 14 days
```

## Artifact Dependency

```yaml
needs:
  - job: build
    artifacts: true
```

The verification and release jobs download only the build artifact they need. The build job depends on the test job but does not download its test artifact.

## Release Behavior

The `publish_release` job runs only for Git tags. It verifies the SHA-256 checksum again and uploads the build package to the GitLab Generic Package Registry using `CI_JOB_TOKEN`.

## Files

- `.gitlab-ci.yml` — Session 54 professional artifact pipeline
- `app.py` — minimal sample application file used by the build package
- `requirements.txt` — minimal project dependency file
- `tests/test_app.py` — simple pytest test used to generate the JUnit report
- `.gitignore` — excludes generated artifact/report directories
- `DevOps_Build_Artifact_Professional_Session_54_Commands_CheatSheet.txt` — commands from this lesson with beginner-friendly English explanations
