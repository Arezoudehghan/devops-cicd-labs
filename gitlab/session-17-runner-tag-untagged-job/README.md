# Session 17 — Runner Tag and Untagged Job

This lab demonstrates how GitLab matches CI/CD jobs to GitLab Runners by using Runner tags and the **Run untagged jobs** setting.

## Learning goals

- Understand the difference between a Runner tag and a Git tag.
- Match a tagged job to the correct GitLab Runner.
- Understand what an untagged job is.
- Test the effect of **Run untagged jobs** being enabled or disabled.
- Understand why a job with the wrong Runner tag remains pending.
- Understand multi-tag matching.
- Troubleshoot pending jobs caused by Runner tag configuration.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1
- **Executor:** `shell`
- **Runner tag:** `dev-shell`

## Core matching rule

A tagged job can run only on a Runner that contains **all** tags requested by the job.

```text
Job tags ⊆ Runner tags
        |
        v
      MATCH
        |
        v
       RUN
```

A Runner may contain additional tags that the job does not request.

## Untagged job rule

A job without a `tags:` section is an untagged job.

- **Run untagged jobs = ON** → the Runner may execute the untagged job.
- **Run untagged jobs = OFF** → the Runner does not execute the untagged job.

Enabling **Run untagged jobs** does not ignore mismatched tags. A job that explicitly requests `docker` still cannot run on a Runner that only has `dev-shell`.

## Main pipeline

The included `.gitlab-ci.yml` is the safe baseline lab. It contains a job that requests:

```yaml
tags:
  - dev-shell
```

The job prints the Runner host, execution user, Runner description, and Runner tags.

## Additional examples

The `examples/` directory contains two separate CI examples used in the lesson:

- `untagged-job.yml` — contains no `tags:` section. Its behavior depends on **Run untagged jobs**.
- `wrong-tag-job.yml` — requests the `docker` tag and should remain pending when the available Runner only has `dev-shell`.

They are kept separate from the main pipeline so the default lab does not intentionally remain pending.

## Multi-tag example

If a job requests:

```yaml
tags:
  - dev-shell
  - linux
```

the Runner must contain both `dev-shell` and `linux`. Extra Runner tags are allowed.

## Troubleshooting checklist

When a GitLab job remains pending, check:

1. Job tags.
2. Runner tags.
3. **Run untagged jobs** for jobs without tags.
4. Runner availability and online status.
5. Runner scope for the project.
6. Protected Runner restrictions when applicable.

## Lab files

- `.gitlab-ci.yml` — tagged-job baseline using `dev-shell`.
- `examples/untagged-job.yml` — untagged-job example.
- `examples/wrong-tag-job.yml` — mismatched-tag example.
- `DevOps_Runner_Tag_Untagged_Job_Session_17_Commands_CheatSheet.txt` — executable commands from this lesson with beginner-friendly English explanations.
- `README.md` — Session 17 lab notes.

## Key idea

Runner tags route jobs to suitable Runners. Untagged jobs are controlled separately by **Run untagged jobs**.
