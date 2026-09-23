# Session 32 — Conditional Pipeline Execution

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on conditional GitLab CI/CD execution based on branch, tag, Merge Request, file changes, CI/CD variables, and scheduled pipelines.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

DEV-2 is not required for this session because the lab focuses on pipeline and job-selection logic rather than deployment.

## Learning Goals

- Understand the difference between `workflow: rules` and job-level `rules`.
- Use `CI_PIPELINE_SOURCE` to distinguish push, Merge Request, schedule, and web pipelines.
- Run jobs conditionally for branches and tags.
- Use `rules:changes` for file-based execution.
- Use custom variables such as `RUN_SECURITY_SCAN` in rules.
- Prevent duplicate branch pipelines when a Merge Request is already open.
- Create release jobs for semantic-version tags.
- Run maintenance jobs only from pipeline schedules.

## Project Structure

```text
.
├── .gitlab-ci.yml
├── Dockerfile
├── docker/
│   └── config.txt
├── docs/
│   └── README.md
└── src/
    └── app.txt
```

## Pipeline Behavior

- Push to a normal branch → `branch_push`.
- Push to the default branch → `branch_push` and `main_branch`.
- Merge Request pipeline → `merge_request_test`.
- Docker-related file changes in a Merge Request → `docker_changes`.
- `RUN_SECURITY_SCAN=true` → `security_scan`.
- Tag such as `v1.0.0` → `release_tag`.
- Scheduled pipeline → `scheduled_job`.
- Open Merge Request + branch push → duplicate branch pipeline is blocked by `workflow: rules`.

## Files

- `.gitlab-ci.yml` — Conditional pipeline configuration for Session 32.
- `Dockerfile` — Minimal Dockerfile used by the file-change lab.
- `src/app.txt` — Small application file used for source-change tests.
- `docker/config.txt` — Docker-related file used by `rules:changes`.
- `docs/README.md` — Documentation file for change-based testing.
- `DevOps_Conditional_Pipeline_Rules_Session_32_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
