# Session 08 — Branching Strategy

Chapter 2 — Git and GitLab for CI/CD

## Topics

- GitLab Flow
- Feature Branch
- Release Branch
- Hotfix Branch
- Merge Request workflow
- Release tags
- Hotfix forward-port to `main`
- Cleanup of short-lived branches

## Lab Scenario

The lab uses a simple application file to practice a production-style branching workflow.

Branch flow:

```text
main
 ├── feature/add-health-message
 │    └── Merge Request -> main
 │
 └── release/1.1
      ├── tag: v1.1.0
      └── hotfix/fix-health-status
           └── Merge Request -> release/1.1
                └── tag: v1.1.1

Hotfix change is also forward-ported to main.
```

## Branch Rules Used in This Lab

- `feature/*` branches are created from the latest `main`.
- Feature changes return to `main` through a Merge Request.
- `release/*` branches are created from `main` when a release is stabilized.
- New features are not added to a stabilized release branch.
- `hotfix/*` branches are created from the release currently representing production.
- A production hotfix is merged back into the release branch and also carried forward to `main`.
- Feature and hotfix branches are short-lived and removed after merge.
- `main` and `release/*` remain long-lived branches in this lab.

## Release History

- `v1.0.0` — initial application
- `v1.1.0` — release with health status feature
- `v1.1.1` — production hotfix release

## Important Git History Command

```bash
git log --graph --oneline --decorate --all
```

This shows the commit graph, branches, merge commits, and tags used throughout the lab.

## Files

- `app.txt` — final application state from the lab
- `DevOps_Branching_Strategy_Session_08_Commands_CheatSheet.txt` — commands used in Session 08 with beginner-friendly English explanations
