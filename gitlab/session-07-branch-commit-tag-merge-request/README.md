# Session 07 — Branch, Commit, Tag and Merge Request

This lab practices the Git and GitLab workflow used before building CI/CD pipelines.

## Learning goals

- Understand how Git branches point to commits.
- Create feature branches without working directly on `main`.
- Stage and commit changes with clear commit messages.
- Push local branches to GitLab and configure upstream tracking.
- Create and understand a GitLab Merge Request.
- Read a Git commit graph and identify merge commits.
- Understand `HEAD`, local branches, and remote-tracking branches.
- Create and push annotated release tags.
- Relate Git tags to versioned CI/CD releases and artifacts.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab:** hosted on DEV-1
- **Local lab path:** `~/labs/git-session7-lab`
- **Main branch:** `main`
- **Feature branch:** `feature/add-healthcheck`
- **Release tag:** `v1.0.0`

## Workflow

```text
main
  ↓
feature/add-healthcheck
  ↓
Change
  ↓
git add
  ↓
git commit
  ↓
git push
  ↓
Merge Request
  ↓
Review / Merge
  ↓
main
  ↓
v1.0.0
```

## Example history from the lab

```text
*   78b54f6 (HEAD -> main, origin/main) Merge branch 'feature/add-healthcheck' into 'main'
|\
| * dc8b17d (origin/feature/add-healthcheck, feature/add-healthcheck) docs: add health check documentation
|/
* 3bfce4b chore: initialize repository
```

## Lab files

- `healthcheck.md` — health-check documentation added on the feature branch.
- `DevOps_Branch_Commit_Tag_Merge_Request_Session_7_Commands_CheatSheet.txt` — all unique executable commands from this lesson with beginner-friendly English explanations.

## Key idea

- **Branch** — where development continues.
- **Commit** — a recorded snapshot of staged changes.
- **Merge Request** — the GitLab review and merge workflow.
- **Tag** — a fixed reference to an important commit, commonly a release version.
