# Session 15 — Register GitLab Runner

This lab demonstrates how to register a GitLab Runner with a self-managed GitLab instance and verify that the Runner can execute a real CI job.

## Learning goals

- Understand the difference between installing and registering GitLab Runner.
- Create a Project Runner in GitLab.
- Use a Runner Authentication Token.
- Register the Runner with the Shell executor.
- Assign and use the `s15-shell` Runner tag.
- Verify the local Runner configuration and GitLab connectivity.
- Test the registered Runner with a real GitLab CI pipeline.
- Troubleshoot common Runner registration and pending-job problems.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1
- **Runner name:** `dev-1-s15-shell`
- **Runner tag:** `s15-shell`
- **Executor:** `shell`
- **GitLab URL:** `http://192.168.94.90`
- **Runner config:** `/etc/gitlab-runner/config.toml`

DEV-2 is not required for this session because this lab focuses on Runner registration and job execution on DEV-1.

## Registration workflow

```text
GitLab Project
    |
    v
Create Project Runner
    |
    v
Runner Authentication Token
    |
    v
DEV-1
    |
    v
gitlab-runner register
    |
    v
Shell Executor
    |
    v
/etc/gitlab-runner/config.toml
    |
    v
Runner Online
    |
    v
Job tag: s15-shell
    |
    v
Pipeline runs on DEV-1
```

## Runner registration

The Runner is registered against:

```text
http://192.168.94.90
```

The authentication token is entered interactively into a shell variable and is not stored in this repository.

The registration uses:

```text
Runner name: dev-1-s15-shell
Executor: shell
Tag: s15-shell
```

## Pipeline test

The included `.gitlab-ci.yml` contains one verification job.

The job:

- Requires the `s15-shell` Runner tag.
- Prints the Runner host name.
- Prints the user executing the job.
- Prints GitLab predefined variables.
- Prints kernel information.

A successful job confirms that GitLab matched the job to the registered Runner and that the Shell executor executed the script on DEV-1.

## Troubleshooting focus

The lesson checks:

- Runner service status.
- GitLab connectivity from DEV-1.
- Locally registered Runner configurations.
- Runner verification against GitLab.
- Runner service logs.
- Proxy environment variables.
- Job tags when a job remains pending.

## Security note

Do not commit the real Runner Authentication Token to Git.

The token is intentionally represented only as the shell variable:

```text
$RUNNER_TOKEN
```

## Lab files

- `.gitlab-ci.yml` — verification pipeline for the newly registered Runner.
- `DevOps_GitLab_Runner_Registration_Session_15_Commands_CheatSheet.txt` — all unique executable commands from this lesson with beginner-friendly English explanations.
- `README.md` — lab notes and architecture for Session 15.

## Key idea

Installing GitLab Runner only places the Runner software on the host. Registration connects that Runner configuration to GitLab, and the Runner tag allows matching CI jobs to the correct Runner.
