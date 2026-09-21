# Session 10 — Merge Request Pipeline

This lab demonstrates how to create a real GitLab Merge Request Pipeline and use it as a quality gate before changes are merged into `main`.

## Learning goals

- Understand the difference between a branch pipeline and a Merge Request pipeline.
- Detect Merge Request pipelines with `CI_PIPELINE_SOURCE == "merge_request_event"`.
- Use GitLab Merge Request predefined variables.
- Control pipeline creation with `workflow: rules`.
- Control individual jobs with job-level `rules`.
- Prevent duplicate branch and Merge Request pipelines.
- Fail a Merge Request pipeline when a health check fails.
- Fix the source branch and observe the Merge Request pipeline run again.
- Use `Pipelines must succeed` as a merge gate.
- Understand the difference between a Merge Request Pipeline and a Merged Results Pipeline.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** Shell executor
- **Runner tag:** `dev-shell`
- **Default branch:** `main`
- **Feature branch:** `feature/break-health-check`
- **Lab repository:** `mr-pipeline-lab`

DEV-2 is not required for this session because this lab validates code before merge and does not deploy an application.

## Workflow

```text
Developer
   |
   v
feature/break-health-check
   |
   v
Merge Request
   |
   v
Merge Request Pipeline
   |
   +-- show-mr-context
   |
   +-- mr-health-check
           |
      +----+----+
      |         |
    FAIL       PASS
      |         |
      v         v
Merge blocked  Merge allowed
                |
                v
               main
                |
                v
        main-health-check
```

## Pipeline behavior

The pipeline is created for two cases:

1. A Merge Request event.
2. A pipeline on the default branch.

Feature-branch push pipelines are intentionally suppressed by the final `when: never` workflow rule. This avoids duplicate push and Merge Request pipelines for the same work.

### Merge Request context job

The `show-mr-context` job prints:

- `CI_PIPELINE_SOURCE`
- `CI_MERGE_REQUEST_IID`
- `CI_MERGE_REQUEST_SOURCE_BRANCH_NAME`
- `CI_MERGE_REQUEST_TARGET_BRANCH_NAME`
- `CI_COMMIT_SHORT_SHA`

For a real Merge Request pipeline, the important value is:

```text
CI_PIPELINE_SOURCE=merge_request_event
```

### Health-check job

The Merge Request test verifies that `app/health.txt` exists and contains exactly:

```text
healthy
```

The lesson intentionally changes the file to `unhealthy` first so the Merge Request pipeline fails. The branch is then fixed and pushed again so a new Merge Request pipeline passes.

## GitLab merge gate

In GitLab, enable:

```text
Settings
-> Merge requests
-> Merge checks
-> Pipelines must succeed
```

With this setting enabled, a failed required pipeline blocks the Merge Request from being merged.

## Lab files

- `.gitlab-ci.yml` — Merge Request and main-branch pipeline rules and jobs.
- `app/health.txt` — simple health-state file used by the test job.
- `DevOps_Merge_Request_Pipeline_Session_10_Commands_CheatSheet.txt` — all unique executable commands from the lesson with beginner-friendly English explanations.

## Key idea

A Merge Request Pipeline validates changes in the context of an open Merge Request before they enter the target branch. It is not the same as a Merged Results Pipeline, which tests a temporary combined result of source and target branches.
