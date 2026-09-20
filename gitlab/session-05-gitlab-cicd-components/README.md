# Session 05 — GitLab CI/CD Components

This lab introduces the core components of GitLab CI/CD and shows how they work together in a practical pipeline.

## Learning goals

- Understand Repository, Pipeline, Job, and Stage.
- Understand the difference between GitLab Runner and Executor.
- Use the `dev-shell` Runner with the Shell executor.
- Create and pass build output as an Artifact.
- Use Cache for reusable pipeline data.
- Use GitLab CI/CD Variables and predefined variables.
- Deploy an artifact to DEV-2 over SSH.
- Track the deployment with a GitLab Environment named `development`.

## Lab environment

- **DEV-1:** `192.168.94.90` — GitLab CE, GitLab Runner, CI/CD tools
- **DEV-2:** `192.168.94.91` — deployment target
- **Runner tag:** `dev-shell`
- **Executor:** `shell`
- **GitLab environment:** `development`

## Pipeline flow

```text
Repository
   ↓
Pipeline
   ↓
Build
   └── build_package
         ├── Artifact: dist/
         └── Cache: .cache/
   ↓
Test
   └── test_package
   ↓
Deploy
   └── deploy_development
         ↓
       DEV-2
         ↓
Environment: development
```

## Files

- `.gitlab-ci.yml` — build, test, artifact, cache, SSH deploy, and environment pipeline
- `.gitignore` — ignores generated artifact and cache directories
- `DevOps_GitLab_CICD_Components_Session_5_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations

## Important GitLab CI/CD variables

The deploy job expects these GitLab **File** variables:

- `SSH_PRIVATE_KEY`
- `SSH_KNOWN_HOSTS`

The pipeline also uses these normal variables:

- `APP_NAME=cicd-session5-components`
- `DEPLOY_HOST=192.168.94.91`
- `DEPLOY_USER=deploy`
