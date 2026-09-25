# Session 43 — Transfer Outputs Between Jobs

Chapter 5 — Dependency, Artifact and Cache

This lab demonstrates how to transfer build outputs between GitLab CI/CD jobs with job artifacts, `dependencies`, and `needs:artifacts`.

## Topics

- Producer and consumer jobs
- `artifacts:paths`
- Artifact upload and download flow
- Default artifact download behavior between stages
- Selecting artifact sources with `dependencies`
- Disabling artifact downloads with `dependencies: []`
- DAG dependencies with `needs`
- `needs:artifacts: true` and `artifacts: false`
- Build once, test the same artifact, and package the same artifact
- Artifact integrity verification with SHA-256
- Troubleshooting missing or expired artifacts

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Example local lab directory: `~/gitlab-labs/artifact-transfer-lab`

## Artifact Flow

```text
build_app
   |
   | uploads dist/
   v
GitLab Artifact Storage
   |
   +--------------------------+
   |                          |
   v                          v
test_app                  package_app
verify file               create release archive
verify checksum           reuse build artifact
```

The build job creates:

- `dist/app.txt`
- `dist/app.sha256`

The test job downloads the build artifact and verifies both the file and its SHA-256 checksum.

The package job waits for the test job to pass while downloading the original artifact directly from `build_app`.

## Files

- `.gitlab-ci.yml` — final artifact-transfer pipeline for Session 43
- `DevOps_Artifact_Transfer_Between_Jobs_Session_43_Commands_CheatSheet.txt` — all unique executable commands used in the lesson with beginner-friendly English explanations
