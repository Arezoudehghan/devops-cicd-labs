# DevOps CI/CD Labs

Hands-on CI/CD labs focused on GitLab pipelines, runners, testing, artifacts, security, Docker image workflows, deployment, rollback, monitoring, and production-ready practices.

## Repository Structure

- `gitlab/` — GitLab CI/CD lessons and labs
- `pipelines/` — reusable pipeline patterns
- `security/` — DevSecOps and pipeline security
- `deployment/` — deployment strategies and rollback
- `monitoring/` — CI/CD monitoring and observability
- `final-project/` — end-to-end CI/CD project

## Current Labs

- `gitlab/session-01-gitlab-cicd-basics/` — CI/CD basics, Runner, stages, jobs, predefined variables, artifacts, and CI Lint.
- `gitlab/session-04-shift-left-fail-fast/` — Shift Left, Fail Fast, syntax validation, unit testing, secret scanning, packaging, SSH deployment, and health checking.
- `gitlab/session-05-gitlab-cicd-components/` — GitLab Repository, Pipeline, Job, Stage, Runner, Executor, Artifact, Cache, Variables, and Environments.
- `gitlab/session-06-git-for-devops/` — Git review for DevOps: working tree, staging, commits, remotes, SSH, fetch/pull/push, reset, revert, and reflog.
- `gitlab/session-07-branch-commit-tag-merge-request/` — Branch, commit, feature workflow, GitLab Merge Request, merge commits, HEAD, remote-tracking branches, and release tags.
- `gitlab/session-08-branching-strategy/` — GitLab Flow, feature branches, release branches, hotfix branches, release tags, forward-porting fixes, and branch cleanup.
- `gitlab/session-09-protected-branch-protected-tag/` — GitLab Protected Branch, Protected Tag, direct-push restrictions, Merge Request flow, release-tag protection, and protected CI/CD variables.
- `gitlab/session-10-merge-request-pipeline/` — GitLab Merge Request Pipelines, workflow rules, MR predefined variables, pipeline merge gates, health-check failure/fix flow, and duplicate-pipeline prevention.
- `gitlab/session-11-merge-request-and-merged-results-pipeline/` — Standard Merge Request Pipeline, MR context variables, source-vs-target integration risk, and merged-result simulation for GitLab CE.
- `gitlab/session-13-gitlab-runner-job-flow/` — GitLab Runner job request flow, Runner tags, Shell executor, predefined Runner variables, pending-job troubleshooting, and Runner verification.
- `gitlab/session-12-team-workflow/` — Enterprise team workflow with short-lived branches, Merge Requests, CI quality gates, code review, approval, and merge-to-main policy.
- `gitlab/session-14-gitlab-runner-installation-linux/` — Install and verify GitLab Runner on Linux, inspect systemd service and logs, understand `config.toml`, and validate Docker access for the Runner user.
- `gitlab/session-16-gitlab-runner-scope/` — Instance, Group, and Project Runner scope, Runner tags vs scope, Shell executor, multi-runner lab, and negative scope testing.
- `gitlab/session-15-register-gitlab-runner/` — Register a GitLab Runner, use the Shell executor, apply Runner tags, verify connectivity, and run a real CI job.
- `gitlab/session-18-shell-executor/` — Shell Executor internals, Runner user and host inspection, filesystem access, permissions, Docker access, PATH, and troubleshooting.
- `gitlab/session-17-runner-tag-untagged-job/` — GitLab Runner tag matching, untagged jobs, `Run untagged jobs`, multi-tag matching, and pending-job troubleshooting.
- `gitlab/session-20-shell-docker-kubernetes-executors/` — Compare GitLab Runner Shell, Docker, and Kubernetes executors, including isolation, dependency management, security trade-offs, and a practical Shell-vs-Docker pipeline.
- `gitlab/session-21-concurrent-job-runner-capacity/` — GitLab Runner concurrent jobs, global `concurrent`, per-runner `limit`, `request_concurrency`, capacity testing, and Runner process monitoring.
- `gitlab/session-22-runner-security-shell-executor/` — GitLab Runner security, Shell Executor risks, Runner-user permissions, Docker-group privilege, CI/CD secret exposure, and Runner hardening.
- `gitlab/session-23-runner-troubleshooting/` — GitLab Runner troubleshooting for pending/stuck jobs, offline Runner, tag mismatch, Linux permissions, Docker socket access, and diagnostic workflow.
- `gitlab/session-24-yaml-structure-indentation/` — YAML mappings, sequences, indentation, GitLab CI/CD parent/child structure, tab detection, and a practical `.gitlab-ci.yml` validation lab.
- `gitlab/session-25-job-and-stage/` — GitLab CI/CD Job and Stage definitions, stage ordering, same-stage parallel jobs, failure gating, Runner tags, and a practical validate/build/test/deploy pipeline.
- `gitlab/session-26-script-before-script-after-script/` — GitLab CI/CD `before_script`, `script`, and `after_script`, shell-context behavior, failure handling, and artifact updates.
- `gitlab/session-27-pipeline-variables/` — GitLab CI/CD global variables, job-level scope, predefined variables, project secrets, variable precedence, and a practical pipeline-variable lab.
- `gitlab/session-28-predefined-variables/` — GitLab predefined variables, commit SHA tracking, branch-vs-tag pipelines, pipeline IDs, Runner project paths, and rules-based job selection.
- `gitlab/session-29-rules/` — GitLab CI/CD `rules`, first-match behavior, branch/tag/Merge Request conditions, `changes`, `exists`, manual jobs, and a practical rules lab.
- `gitlab/session-30-workflow-rules/` — GitLab CI/CD `workflow: rules`, pipeline creation control, branch/tag/Merge Request policies, duplicate-pipeline prevention, and pre-pipeline variable usage.
- `gitlab/session-31-rules-vs-only-except/` — Compare GitLab CI/CD `rules` with legacy `only/except`, first-match behavior, `when: never`, branch/Merge Request conditions, and migration patterns.\n- `gitlab/session-32-conditional-pipeline-rules/` — Conditional GitLab CI/CD execution based on branch, tag, Merge Request, file changes, variables, and schedules.\n