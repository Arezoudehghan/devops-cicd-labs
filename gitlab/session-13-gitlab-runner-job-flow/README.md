# Session 13 — GitLab Runner Job Flow

This lab explains what a GitLab Runner is and how a CI/CD job moves from GitLab to a Runner and then to the configured executor.

## Learning goals

- Understand the difference between GitLab, GitLab Runner, and an executor.
- Understand that the Runner requests compatible jobs from GitLab.
- See how Runner tags participate in job matching.
- Inspect Runner predefined CI/CD variables during a real job.
- Verify that the Shell executor runs commands directly on the Runner host.
- Reproduce a pending job by intentionally using a tag that no Runner has.
- Troubleshoot Runner service state, registration, connectivity, and logs.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** hosted on DEV-1
- **Runner name:** `dev-1`
- **Runner tag:** `dev-shell`
- **Executor:** `shell`
- **Example GitLab project:** `runner-session13-lab`

## Runner job flow

```text
Developer
   |
   | git push
   v
GitLab Repository
   |
   v
.gitlab-ci.yml
   |
   v
Pipeline
   |
   v
Job Queue
   |
   | Runner requests a compatible job
   v
GitLab Runner
   |
   v
Shell Executor
   |
   v
Commands execute on DEV-1
   |
   v
Logs + job status return to GitLab
```

GitLab does not normally push the job directly into the Runner. The Runner contacts GitLab and requests work. GitLab then checks whether the Runner is eligible for a queued job.

## Job matching

The lab job requests this Runner tag:

```yaml
tags:
  - dev-shell
```

The configured Runner must have every tag requested by the job.

The intentional mismatch test changes the required tag to:

```yaml
tags:
  - no-such-runner
```

With no eligible Runner, the job remains pending instead of reaching the `script:` commands.

## Runner inspection pipeline

The session pipeline is stored in `.gitlab-ci.yml`.

It prints:

- `CI_RUNNER_ID`
- `CI_RUNNER_DESCRIPTION`
- `CI_RUNNER_TAGS`
- `CI_RUNNER_VERSION`
- `CI_RUNNER_EXECUTABLE_ARCH`
- `CI_PROJECT_DIR`
- the effective user
- the hostname
- the working directory
- Linux user/group information
- kernel and system information

Because this Runner uses the Shell executor, these commands run directly on DEV-1 under the Runner execution account.

## Useful Runner checks

```bash
gitlab-runner --version
sudo systemctl status gitlab-runner --no-pager
sudo systemctl is-active gitlab-runner
sudo gitlab-runner list
sudo gitlab-runner verify
sudo gitlab-runner lint --config /etc/gitlab-runner/config.toml
sudo journalctl -u gitlab-runner -f
```

A filtered configuration check can be used without printing the Runner authentication token:

```bash
sudo grep -E '^[[:space:]]*(name|url|executor|shell|limit|request_concurrency)[[:space:]]*=' /etc/gitlab-runner/config.toml
```

## Lab files

- `README.md` — session notes and Runner job-flow explanation.
- `.gitlab-ci.yml` — Runner inspection pipeline used by the lab.
- `DevOps_GitLab_Runner_Session_13_Commands_CheatSheet.txt` — all unique executable commands from this lesson with beginner-friendly English explanations.

## Key idea

A GitLab Runner is the execution agent. It requests compatible jobs from GitLab, hands the job to its configured executor, runs the commands, and returns logs and status to GitLab.
