# Session 81 — Parent-Child Pipeline

This lab demonstrates how to split a large GitLab CI/CD pipeline into a Parent Pipeline and multiple Child Pipelines.

## Architecture

```text
Parent Pipeline
├── Quality Child
│   ├── Lint
│   └── Unit Test
├── Security Child
│   ├── Secret Scan
│   └── Config Scan
└── Delivery Child
    ├── Docker Build
    ├── Container Scan
    ├── Push Registry
    └── Deploy
```

## Files

- `.gitlab-ci.yml` — Parent Pipeline and trigger jobs
- `.gitlab/ci/quality.yml` — Quality Child Pipeline
- `.gitlab/ci/security.yml` — Security Child Pipeline
- `.gitlab/ci/delivery.yml` — Delivery Child Pipeline
- `DevOps_Parent_Child_Pipeline_Session_81_Commands_CheatSheet.txt` — commands cheat sheet

## Runner

The executable jobs in the Child Pipelines use the Runner tag:

```text
dev-shell
```

Trigger jobs in the Parent Pipeline do not require a Runner.

## GitLab Version Note

This lesson uses `strategy: mirror`, which is the recommended behavior on GitLab 18.2 and later. On an older GitLab version, use `strategy: depend` instead.
