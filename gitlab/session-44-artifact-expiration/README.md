# Session 44 — GitLab CI/CD Artifact Expiration

This lab demonstrates how GitLab CI/CD controls job-artifact retention with `artifacts:expire_in` and how later jobs can consume artifacts before they expire.

## Topics

- Artifact retention and storage management
- `artifacts:expire_in`
- Expiration values such as minutes, hours, days, weeks, months, and `never`
- GitLab instance default artifact expiration
- Latest successful pipeline artifact retention
- Periodic cleanup of expired artifacts
- Artifact transfer with `dependencies`
- Risks of choosing an expiration time that is too short
- Artifact retention policy versus long-term package/image storage

## Lab Environment

- Main host: DEV-1
- DEV-1 IP: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`

## Pipeline Flow

```text
build_artifact
      |
      v
verify_artifact
```

The `build_artifact` job creates `dist/build-info.txt`, uploads the `dist/` directory as a job artifact, and sets:

```yaml
expire_in: 2 minutes
```

The `verify_artifact` job explicitly downloads the artifact from `build_artifact` through:

```yaml
dependencies:
  - build_artifact
```

It then verifies that `dist/build-info.txt` exists and prints its contents.

## Artifact Expiration Notes

GitLab calculates the artifact expiration time from when the artifact is stored. Expiration does not always mean immediate physical deletion because cleanup is periodic.

The most recent successful pipeline artifacts for a branch or tag can also be retained depending on the project's artifact settings, so a short `expire_in` value does not always make the newest successful artifact disappear immediately.

## Files

- `.gitlab-ci.yml` — Session 44 artifact-expiration lab pipeline
- `DevOps_Artifact_Expiration_Session_44_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
