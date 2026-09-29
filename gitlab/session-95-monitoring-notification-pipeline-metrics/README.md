# Session 95 — Monitoring, Notification and Pipeline Metrics

فصل یازدهم: Troubleshooting و Performance

این Lab برای مانیتورینگ Pipeline و GitLab Runner طراحی شده است و شامل Pipeline کنترل‌شده برای ایجاد Failure، Metrics مربوط به Runner، Scrape توسط Prometheus و آماده‌سازی داده برای Grafana و Alerting است.

## Lab Architecture

- DEV-1 — `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Runner Metrics endpoint: `:9252/metrics`
- DEV-2 — `192.168.94.91`
  - Prometheus
  - Grafana
  - Monitoring services

## Files

- `.gitlab-ci.yml` — Pipeline آزمایشی با مراحل test/build/deploy و متغیر `FORCE_FAIL`
- `runner/config.toml.example` — نمونه فعال‌سازی Runner Prometheus Metrics روی پورت 9252
- `prometheus/prometheus.yml` — Scrape configuration برای GitLab Runner روی DEV-1
- `DevOps_Monitoring_Notification_Pipeline_Metrics_Session_95_Commands_CheatSheet.txt` — Cheat Sheet دستورات همین جلسه

## Pipeline Failure Scenario

برای Pipeline سالم، `FORCE_FAIL` را خالی یا `false` قرار دهید.

برای ایجاد Failure کنترل‌شده:

```text
FORCE_FAIL=true
```

در این حالت Job مربوط به `unit_test` با `exit 1` Fail می‌شود و می‌توان تغییر Success Rate و Failure Rate را بررسی کرد.

## Runner Metrics

روی DEV-1 تنظیم `listen_address = "0.0.0.0:9252"` را به بخش Global فایل `/etc/gitlab-runner/config.toml` اضافه کنید و Runner را Restart کنید.

Metrics endpoint:

```text
http://192.168.94.90:9252/metrics
```

## Prometheus

فایل `prometheus/prometheus.yml` Target زیر را Scrape می‌کند:

```text
192.168.94.90:9252
```

## Useful PromQL

```promql
gitlab_runner_jobs
```

```promql
gitlab_runner_limit
```

```promql
100 * (gitlab_runner_jobs / gitlab_runner_limit)
```

```promql
rate(gitlab_runner_errors_total[5m])
```

## Session Goals

- Pipeline Success Rate
- Pipeline Failure Rate
- Job Duration
- Deployment Frequency
- Notification
- Failed Pipeline Alert
- Reporting
- Runner Utilization
