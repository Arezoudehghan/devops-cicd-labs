# Session 30 — workflow: rules

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on GitLab CI/CD `workflow: rules`, pipeline creation control, pipeline sources, Merge Request pipelines, tag pipelines, and duplicate-pipeline prevention.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

DEV-2 is not required for this session because the lab focuses on pipeline creation logic rather than deployment.

## Learning Goals

- Understand the difference between `workflow: rules` and job-level `rules`.
- Control whether GitLab creates a pipeline for a specific event.
- Use `CI_PIPELINE_SOURCE` to identify why a pipeline was triggered.
- Create branch, Merge Request, and tag pipeline policies.
- Use `CI_OPEN_MERGE_REQUESTS` to prevent duplicate branch and Merge Request pipelines.
- Understand why pre-pipeline variables are required for workflow decisions.
- Combine pipeline-level workflow rules with job-level rules.

## Pipeline Policy

The lab uses this workflow policy:

- Merge Request pipeline → allowed.
- Tag pipeline → allowed.
- Push to a branch that already has an open Merge Request → branch pipeline blocked.
- Normal branch pipeline → allowed.
- Other pipeline sources → blocked.

The key rule that prevents duplicate push pipelines is:

```yaml
- if: '$CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS && $CI_PIPELINE_SOURCE == "push"'
  when: never
```

## Pipeline Structure

The included `.gitlab-ci.yml` defines four stages:

```text
inspect
   |
   v
test
   |
   v
build
   |
   v
deploy
```

The jobs are:

- `show_pipeline_context`
- `test_app`
- `build_app`
- `deploy_app`

## Test Scenarios

Use the lab to verify these cases:

- Push to `main`.
- Push to a feature branch without an open Merge Request.
- Create a Merge Request.
- Push again while the Merge Request is open.
- Create and push a Git tag.

The `show_pipeline_context` job prints the relevant predefined variables so each pipeline type can be identified clearly.

## Files

- `.gitlab-ci.yml` — Session 30 workflow-rules pipeline.
- `app.txt` — Small application file used by the test and build jobs.
- `DevOps_Workflow_Rules_Session_30_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
