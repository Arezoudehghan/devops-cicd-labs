# Session 36 — Split Pipeline with `include`

This lab demonstrates how to split a large GitLab CI/CD pipeline into smaller reusable YAML files with `include`.

## Topics

- `include:local` for files in the same repository
- Pipeline configuration composition
- Hidden jobs shared across included files
- `extends` across included YAML files
- Build artifacts and `needs`
- Branch-aware deployment with `rules`
- Central CI/CD template concepts with `include:project`
- Remote and built-in template include concepts
- Conditional includes and monorepo patterns
- Configuration merge behavior and YAML anchor scope

## Repository Structure

```text
.
├── .gitlab-ci.yml
└── .gitlab
    └── ci
        ├── templates.yml
        ├── build.yml
        ├── test.yml
        └── deploy.yml
```

## Pipeline

```text
build-application
       |
       v
test-application
       |
       v
deploy-application
```

The main `.gitlab-ci.yml` acts as the pipeline orchestrator and imports the job definitions from `.gitlab/ci/`.

## Lab Environment

- GitLab Runner: Shell executor
- Runner tag: `dev-shell`
- Main lab host: DEV-1
- Build output: `dist/application.txt`
- Deployment job: runs on the default branch

## Key Design Pattern

```text
.gitlab-ci.yml
      |
      +--> templates.yml
      +--> build.yml
      +--> test.yml
      +--> deploy.yml
      |
      v
Merged GitLab CI configuration
```

`include` composes files into the final GitLab CI/CD configuration, while `extends` reuses job configuration.
