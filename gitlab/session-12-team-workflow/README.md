# Session 12 — Team Workflow for Enterprise Environments

Chapter 2 — Git and GitLab for CI/CD

## Topics

- Team Git workflow for an organizational environment
- Protected `main` branch
- `feature/*`, `bugfix/*`, and `hotfix/*` branches
- Merge Request workflow
- CI pipeline as a quality gate
- Code review and approval
- Branch cleanup after merge
- Relationship between Git workflow and CI/CD deployment

## Team Workflow

```text
Task / Issue
    ↓
Update main
    ↓
Create short-lived branch
    ↓
Development
    ↓
Commit
    ↓
Push
    ↓
Merge Request
    ↓
CI Pipeline
    ↓
Code Review
    ↓
Approval
    ↓
Merge to main
    ↓
Deployment
```

## Branch Model

```text
main
 ├── feature/*
 ├── bugfix/*
 └── hotfix/*
```

The `main` branch represents the stable branch. Changes should enter it through a Merge Request after review and successful CI checks.

## Lab Scenario

The Session 12 lab creates a short-lived feature branch named:

```text
feature/session12-workflow
```

The lab creates `workflow.txt`, commits it, pushes the feature branch, opens a Merge Request, merges the change into `main`, and verifies the final Git history.

## Workflow Rules Used in This Lab

- Start new work from the latest `main`.
- Do not develop directly on `main`.
- Use descriptive short-lived branch names.
- Push the working branch to the remote repository.
- Use a Merge Request before changes enter `main`.
- Run CI checks before merge.
- Review and approve changes before merge.
- Delete short-lived branches after they are safely merged.
- Keep commits small and logically focused.
- Do not store secrets in the repository.

## Important Verification Command

```bash
git log --oneline --graph --decorate --all
```

This displays the compact commit history, branch graph, and reference names used to verify the workflow.

## Files

- `workflow.txt` — final lab file created during the Session 12 workflow exercise
- `DevOps_Team_Workflow_Session_12_Commands_CheatSheet.txt` — all executable commands used in Session 12 with beginner-friendly English explanations
