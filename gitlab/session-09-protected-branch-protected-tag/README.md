# Session 09 — Protected Branch and Protected Tag

This lab practices protecting sensitive GitLab branches and release tags before using them in a production CI/CD workflow.

## Learning goals

- Understand why protected branches are used for sensitive branches such as `main`.
- Block direct pushes to `main` and require changes to arrive through Merge Requests.
- Separate the permission to merge from the permission to push directly.
- Keep force push disabled on protected branches.
- Protect release tags such as `v1.0.0` with the wildcard pattern `v*`.
- Test branch protection by intentionally attempting a direct push to `main`.
- Create and push an annotated release tag.
- Understand how protected branches, protected tags, and protected CI/CD variables work together.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab:** hosted on DEV-1
- **Example repository path:** `~/gitlab-labs/cicd-pipeline-lab`
- **Protected branch:** `main`
- **Test branch:** `test/session9-direct-push`
- **Protected tag pattern:** `v*`
- **Example release tag:** `v1.0.0`

## Protected branch policy

```text
main

Allowed to merge:
Maintainers

Allowed to push and merge:
No one

Allowed to force push:
OFF
```

The intended workflow is:

```text
Developer
   |
   v
feature / test branch
   |
   | push
   v
Merge Request
   |
   | review and merge
   v
main
```

## Protected tag policy

```text
Protected tag:
v*

Allowed to create:
Maintainers
```

This protects version tags such as:

```text
v1.0.0
v1.1.0
v2.0.0
```

## Lab workflow

```bash
cd ~/gitlab-labs/cicd-pipeline-lab
git status
git remote -v
git branch -a
git tag
git fetch --all --prune --tags

git switch main
git pull --ff-only origin main
git switch -c test/session9-direct-push

echo "Protected Branch Test - Session 9" >> protected-demo.txt
git add protected-demo.txt
git commit -m "Test protected branch"

git push origin HEAD:main
git push -u origin test/session9-direct-push
```

The direct push to `main` should be rejected when the branch rule is configured correctly. The test branch push should succeed.

After the Merge Request is merged:

```bash
git switch main
git pull --ff-only origin main
git tag -a v1.0.0 -m "Release v1.0.0 - Session 9"
git tag
git show v1.0.0
git push origin v1.0.0
```

A protected release tag should reject deletion through a normal Git push:

```bash
git push origin :refs/tags/v1.0.0
```

## CI/CD relationship

A secure release flow can be designed like this:

```text
feature/*
    |
    v
Merge Request
    |
    v
main [Protected]
    |
    v
v1.0.0 [Protected]
    |
    v
Production Pipeline
    |
    v
DEV-2
```

Protected CI/CD variables can also be restricted so they are available only to pipelines running on protected branches or protected tags.

## Lab files

- `README.md` — session notes and practical workflow.
- `protected-demo.txt` — file used for the protected-branch push test.
- `DevOps_Protected_Branch_Protected_Tag_Session_9_Commands_CheatSheet.txt` — all unique executable commands from this lesson with beginner-friendly English explanations.

## Key idea

- **Protected Branch** controls who can push or merge changes into sensitive branches.
- **Protected Tag** controls who can create important release tags.
- **Merge Request** provides the controlled path for changes to reach `main`.
- **Protected CI/CD Variables** help keep production secrets limited to trusted pipelines.
