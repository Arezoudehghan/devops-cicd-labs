# Session 84 — Scheduled Pipeline and Trigger Pipeline

Practical GitLab CI/CD lab for scheduled pipelines, Cron-based nightly jobs, scheduled security scans, trigger tokens, and API-triggered pipelines.

## Pipeline behavior

- Push pipeline: runs `unit_test`.
- Scheduled pipeline with `SCHEDULE_TYPE=nightly`: runs `nightly_build`.
- Scheduled pipeline with `SCHEDULE_TYPE=security`: runs `scheduled_security_scan`.
- Trigger-token pipeline: runs `external_deploy`.

## GitLab schedules

Create two schedules in **Build > Pipeline schedules**:

Nightly build:

```text
Cron: 0 2 * * *
Target: main
Variable: SCHEDULE_TYPE=nightly
```

Scheduled security scan:

```text
Cron: 0 3 * * *
Target: main
Variable: SCHEDULE_TYPE=security
```

## Trigger API

Create a Pipeline Trigger Token in:

```text
Settings > CI/CD > Pipeline triggers
```

Store the token securely as `GITLAB_TRIGGER_TOKEN` on the external system.

Example:

```bash
curl --request POST \
  --form "token=$GITLAB_TRIGGER_TOKEN" \
  --form "ref=main" \
  --form "variables[DEPLOY_ENV]=staging" \
  "https://gitlab.example.com/api/v4/projects/PROJECT_ID/trigger/pipeline"
```
