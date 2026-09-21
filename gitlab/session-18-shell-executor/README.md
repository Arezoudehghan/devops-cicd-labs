# Session 18 — Shell Executor

This lab demonstrates how the GitLab Runner Shell executor runs CI/CD jobs directly on the Runner host and how to verify the execution user, host, working directory, installed tools, permissions, and host filesystem access.

## Learning goals

- Understand what a GitLab Runner executor does.
- Understand how the Shell executor runs jobs directly on the Runner host.
- Verify that jobs run as the GitLab Runner service user.
- Inspect the Runner host, current directory, environment variables, Git, Docker, and kernel information from a CI job.
- Prove host filesystem access by creating a pipeline-specific file under `/tmp`.
- Understand Shell executor dependency and permission requirements.
- Troubleshoot PATH, Docker access, user permissions, and Shell profile problems.
- Compare Shell executor behavior with Docker executor behavior.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1
- **Runner tag:** `dev-shell`
- **Executor:** `shell`
- **Runner service user:** `gitlab-runner`
- **Runner config:** `/etc/gitlab-runner/config.toml`

DEV-2 is not required for the core lab because this session focuses on direct job execution on the Runner host.

## Execution flow

```text
GitLab
   |
   v
CI Job
   |
   v
Runner tag: dev-shell
   |
   v
GitLab Runner on DEV-1
   |
   v
Shell Executor
   |
   v
Bash
   |
   v
gitlab-runner user
   |
   v
DEV-1 host
```

## Pipeline lab

The included `.gitlab-ci.yml` contains two stages:

```text
inspect
host-test
```

The `inspect-shell` job prints:

- Runner user.
- User and group IDs.
- Hostname.
- Current working directory.
- Home directory.
- Shell.
- `CI_PROJECT_DIR`.
- Git version.
- Docker version.
- Kernel information.

The `host-filesystem-test` job creates:

```text
/tmp/shell-executor-${CI_PIPELINE_ID}.txt
```

This demonstrates that a Shell executor job can write directly to the Runner host filesystem when the Runner user has permission.

## Important concept

With the Shell executor, the CI job does not run inside a dedicated container created by the executor. Commands run directly on the Runner host using the host's installed tools and the permissions of the Runner service user.

For example, a job can use:

```text
docker build
docker ps
python3
git
curl
```

only when those tools are installed and accessible to the Runner user.

## Permission troubleshooting

A command that works as `root` or another interactive user can still fail in the pipeline.

Test the same command as the Runner service user:

```bash
sudo -u gitlab-runner -H bash -lc 'docker ps'
```

Also check:

- Runner user groups.
- Docker socket access.
- PATH.
- Installed packages.
- Shell profiles such as `.bash_logout`.
- Environment variables.
- Proxy settings.

## Security note

Shell executor jobs have limited isolation because they run directly on the Runner host.

Use Shell runners only for trusted projects and grant the `gitlab-runner` user only the permissions required by the jobs.

## Lab files

- `.gitlab-ci.yml` — Shell executor inspection and host-filesystem test pipeline.
- `DevOps_Shell_Executor_Session_18_Commands_CheatSheet.txt` — all unique executable commands from this lesson with beginner-friendly English explanations.
- `README.md` — lab notes and architecture for Session 18.

## Key idea

```text
Shell Executor
Job -> Runner Host
```

The executor determines where the job runs. A Docker command inside a job does not mean the Runner is using Docker executor; a Shell executor can call the Docker CLI installed on the host.
