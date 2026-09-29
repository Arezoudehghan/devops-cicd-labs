# Session 94 — Pipeline Performance and Optimization

This lab demonstrates how GitLab CI/CD pipeline structure affects total execution time.

## Goal

Baseline:

```text
Pipeline Duration ≈ 15 min
```

Optimized target:

```text
Pipeline Duration ≈ 6 min
```

## Files

- `slow-pipeline.gitlab-ci.yml` — intentionally sequential baseline pipeline.
- `.gitlab-ci.yml` — optimized DAG pipeline using `needs`.
- `DevOps_Pipeline_Performance_Optimization_Session_94_Commands_CheatSheet.txt` — commands used in this lesson.

## Baseline Pipeline

The slow version uses separate stages for every job, so each stage waits for the previous stage to finish.

Simulated durations:

- Prepare: 1 minute
- Lint: 2 minutes
- Unit Test: 3 minutes
- Integration Test: 4 minutes
- Docker Build: 3 minutes
- Security Scan: 2 minutes

Total sequential duration is approximately 15 minutes.

## Optimized Pipeline

The optimized pipeline uses `needs` to model real dependencies:

- `lint_job`, `unit_test_job`, `integration_test_job`, and `docker_build_job` need only `prepare_job`.
- `security_scan_job` needs only `docker_build_job`.

This creates a DAG and allows independent jobs to run in parallel when Runner capacity is available.

Critical path:

```text
Prepare 1m
   ↓
Docker Build 3m
   ↓
Security Scan 2m

Critical Path ≈ 6m
```

## Runner Capacity

DAG design alone does not guarantee parallel execution. GitLab Runner must have enough concurrency and the host must have sufficient CPU, RAM, disk I/O, and network capacity.

For the controlled sleep-based lab, a higher concurrency value can demonstrate parallel scheduling. For real builds, benchmark concurrency instead of increasing it blindly.

## Performance Areas Covered

- Pipeline Duration
- Critical Path
- `needs`
- DAG
- Cache
- Artifact
- Parallel Jobs
- Docker Layer Cache
- Runner Resource
- CPU
- RAM
- Disk
- Network

## Key Principle

Optimize the pipeline's critical path and actual bottlenecks instead of assuming that making every individual job faster will reduce total pipeline duration.
