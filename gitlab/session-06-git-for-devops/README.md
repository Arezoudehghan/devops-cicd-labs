# Session 06 — Git Review for DevOps

This lab reviews the Git concepts and commands a DevOps engineer needs before working with CI/CD pipelines.

## Learning goals

- Understand the difference between Git and GitLab.
- Understand Working Directory, Staging Area, Local Repository, and Remote Repository.
- Work with commits, HEAD, commit SHA, logs, diffs, and Git objects.
- Practice `git restore`, `git reset`, `git revert`, and `git reflog`.
- Create and use a bare Git repository as a remote.
- Practice SSH-based Git access between DEV-1 and DEV-2.
- Understand `git fetch`, `git pull`, `git push`, and tracking branches.
- Relate Git commit SHAs to CI/CD traceability.

## Lab environment

- **DEV-1:** `192.168.94.90` — working Git repository
- **DEV-2:** `192.168.94.91` — bare Git remote repository
- **Working repository:** `/opt/git-labs/session6`
- **Bare remote repository:** `/srv/git/session6.git`
- **Remote SSH user:** `deploy`

## Repository model

```text
Working Directory
      ↓ git add
Staging Area
      ↓ git commit
Local Repository
      ↓ git push
Remote Repository
```

## Lab files

- `app.py` — simple application file used to practice Git changes and commits.
- `.gitignore` — ignores logs, environment files, secrets used in the lab, and Python cache files.
- `DevOps_Git_for_DevOps_Session_6_Commands_CheatSheet.txt` — all executable commands from this lesson with beginner-friendly English explanations.

## Security note

SSH private keys, `authorized_keys`, and `known_hosts` are intentionally not stored in this repository. The lesson creates those files directly on the lab hosts.
