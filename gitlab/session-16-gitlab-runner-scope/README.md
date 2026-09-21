# Session 16 — GitLab Runner Scope: Instance, Group, and Project Runner

This lab demonstrates the scope differences between **Instance Runner**, **Group Runner**, and **Project Runner** in GitLab, and separates Runner scope from Runner tags and executor type.

## Learning goals

- Understand the scope of Instance, Group, and Project Runners.
- Understand that Runner scope is different from Runner tags.
- Understand that Runner scope is different from executor type.
- Create three Shell runners with different scopes.
- Verify which runners are available to `app-a` and `app-b`.
- Use `CI_RUNNER_DESCRIPTION` to identify the runner that executed a job.
- Test a negative case where a Project Runner should not be available to another project.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1
- **Executor:** Shell
- **Lab group:** `runner-scope-lab`
- **Projects:** `app-a`, `app-b`

> The lab uses multiple Runner registrations on DEV-1 so scope is the variable being tested. In production, Runner hosts and trust boundaries should be designed separately.

## Runner design

```text
GitLab Instance
│
├── Instance Runner: instance-shell
│      └── Available to projects that allow the Instance Runner
│
└── Group: runner-scope-lab
       │
       ├── Group Runner: group-shell
       │      ├── app-a
       │      └── app-b
       │
       ├── app-a
       │      └── Project Runner: project-shell
       │
       └── app-b
```

Expected scope:

```text
app-a
├── instance-shell
├── group-shell
└── project-shell

app-b
├── instance-shell
└── group-shell
```

## Scope, tags, and executor

These are separate concepts:

```text
Scope
→ Which projects can access the Runner?

Tags
→ Which eligible Runner can match a job?

Executor
→ How and where does the Runner execute the job?
```

In this lab, all three runners use the **Shell executor**, while their scopes are different.

## Pre-check on DEV-1

Check the installed Runner version:

```bash
gitlab-runner --version
```

Check the Runner service:

```bash
sudo systemctl status gitlab-runner --no-pager
```

List current local Runner registrations:

```bash
sudo gitlab-runner list
```

Do not remove existing training runners. New Runner registrations can coexist with the previous Runner configuration.

## Create the Instance Runner

In GitLab:

```text
Admin
→ CI/CD
→ Runners
→ Create instance runner
```

Suggested lab settings:

```text
Description: lab-instance-shell
Tag: instance-shell
Run untagged: Disabled
Executor: shell
```

Register it on DEV-1:

```bash
sudo gitlab-runner register \
  --url "http://192.168.94.90" \
  --token "<INSTANCE_RUNNER_AUTH_TOKEN>"
```

Choose:

```text
shell
```

when GitLab Runner asks for the executor.

## Create the Group Runner

Create the GitLab group:

```text
runner-scope-lab
```

Create these two projects inside it:

```text
app-a
app-b
```

In the group:

```text
Build
→ Runners
→ Create group runner
```

Suggested lab settings:

```text
Description: lab-group-shell
Tag: group-shell
Run untagged: Disabled
Executor: shell
```

Register it on DEV-1:

```bash
sudo gitlab-runner register \
  --url "http://192.168.94.90" \
  --token "<GROUP_RUNNER_AUTH_TOKEN>"
```

## Create the Project Runner

Open `runner-scope-lab/app-a`:

```text
Settings
→ CI/CD
→ Runners
→ Create project runner
```

Suggested lab settings:

```text
Description: lab-project-shell
Tag: project-shell
Run untagged: Disabled
Executor: shell
```

Register it on DEV-1:

```bash
sudo gitlab-runner register \
  --url "http://192.168.94.90" \
  --token "<PROJECT_RUNNER_AUTH_TOKEN>"
```

## Verify the registrations

List local Runner configurations:

```bash
sudo gitlab-runner list
```

Verify that the registered Runners are still recognized by GitLab:

```bash
sudo gitlab-runner verify
```

## app-a test

Use `app-a/.gitlab-ci.yml` in the GitLab `app-a` project.

The pipeline has three jobs:

- `test-instance-runner` requests `instance-shell`.
- `test-group-runner` requests `group-shell`.
- `test-project-runner` requests `project-shell`.

All three jobs should find eligible Runners because `app-a` is inside the scope of all three Runner types.

## app-b test

Use `app-b/.gitlab-ci.yml` in the GitLab `app-b` project.

The pipeline requests only:

- `instance-shell`
- `group-shell`

Both jobs should run because `app-b` is covered by the Instance Runner and the Group Runner.

## Negative test

The optional file `app-b/.gitlab-ci-negative-test.yml` requests:

```text
project-shell
```

If no other Runner with that tag is available to `app-b`, the job should remain pending because the Project Runner created for `app-a` is not automatically inherited by `app-b`.

## Runner identification

The jobs print:

```bash
echo "Runner = $CI_RUNNER_DESCRIPTION"
```

This makes it easy to verify which Runner executed the job.

## Lab files

- `README.md` — Session 16 lab explanation and workflow.
- `app-a/.gitlab-ci.yml` — Pipeline that tests Instance, Group, and Project Runner access.
- `app-b/.gitlab-ci.yml` — Pipeline that tests Instance and Group Runner access.
- `app-b/.gitlab-ci-negative-test.yml` — Optional negative test for the Project Runner scope.
- `DevOps_GitLab_Runner_Scope_Session_16_Commands_CheatSheet.txt` — unique executable commands from this lesson with beginner-friendly English explanations.

## Key idea

```text
Scope ≠ Tag ≠ Executor
```

Runner scope controls project access, tags control job-to-runner matching among eligible runners, and the executor controls how the job is executed.
