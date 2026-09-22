# Session 26 — script, before_script, and after_script

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab demonstrates how GitLab CI/CD runs `before_script`, `script`, and `after_script`, including shell-context behavior, intentional failures, and artifact updates.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

## Learning Goals

- Understand the role of `before_script`.
- Understand the role of `script`.
- Understand the role of `after_script`.
- Verify that `before_script` and `script` share the same shell context.
- Verify that `after_script` starts in a new shell context.
- Observe how files in the workspace remain available to `after_script`.
- Observe how `after_script` behaves when `script` fails.
- Observe that an `after_script` failure does not change a successful main script into a failed job.
- Verify that `after_script` changes are included before artifact upload.

## Jobs

### lifecycle-demo

Demonstrates the normal execution order:

```text
before_script
    |
    v
script
    |
    v
after_script
    |
    v
artifact upload
```

The job also proves that a variable exported in `before_script` is available in `script`, but not in the new shell used by `after_script`.

### script-failure-demo

The main `script` intentionally runs:

```bash
exit 1
```

The job fails, but `after_script` still runs and displays `CI_JOB_STATUS`.

### after-script-failure-demo

The main `script` succeeds, while `after_script` intentionally runs:

```bash
exit 1
```

This demonstrates that a failure in `after_script` does not replace a successful main script exit status.

## Artifact

The lifecycle job creates and updates:

```text
.ci-demo/lifecycle.txt
```

The final artifact contains changes made by `before_script`, `script`, and `after_script`.

## Important Note

The `script-failure-demo` job intentionally fails. Therefore, the overall pipeline is expected to show a failed status during this lab.

## Files

- `.gitlab-ci.yml` — Session 26 practical GitLab CI/CD lab.
- `DevOps_GitLab_CI_script_before_script_after_script_Session_26_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
