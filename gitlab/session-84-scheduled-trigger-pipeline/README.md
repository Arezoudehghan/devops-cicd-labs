# Session 84 — Scheduled Pipeline and Trigger Pipeline

Hands-on GitLab CI/CD lab for scheduled pipelines, cron schedules, trigger tokens, API triggers, nightly jobs, and scheduled security scans.

## Main lab

The root .gitlab-ci.yml demonstrates three pipeline sources:

- push -> push_job
- schedule + SCHEDULE_TYPE=nightly -> nightly_job
- schedule + SCHEDULE_TYPE=security -> scheduled_security_scan
- trigger -> external_trigger_job

The workflow rules allow push, schedule, and trigger pipelines and reject other sources.

## Pipeline schedules

Create the schedules in GitLab under Build > Pipeline schedules.

Nightly schedule:

    Cron: 0 2 * * *
    Target: main
    Variable: SCHEDULE_TYPE=nightly

Security schedule:

    Cron: 0 3 * * *
    Target: main
    Variable: SCHEDULE_TYPE=security

## Trigger pipeline

Create a Pipeline Trigger Token under Settings > CI/CD > Pipeline triggers.

Store the token outside the repository as GITLAB_TRIGGER_TOKEN, then update the GitLab URL and PROJECT_ID in trigger-pipeline.sh before running it.

## Advanced example

examples/advanced.gitlab-ci.yml contains the lesson examples for:

- pytest on push pipelines
- Docker nightly build
- Gitleaks scheduled secret scan
- Trivy scheduled filesystem scan
- external deployment job

The advanced example requires the related tools and project files to exist on the runner/project.
