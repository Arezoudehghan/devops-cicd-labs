# Session 88 — Reusable Pipeline Template

This lab demonstrates reusable GitLab CI/CD configuration with:

- `include`
- reusable templates
- `extends`
- hidden jobs
- DRY pipelines
- version-pinned templates
- GitLab CI/CD Components
- `spec:inputs`

## Structure

```text
session-88-reusable-pipeline-template/
├── .gitlab-ci.yml
├── Dockerfile
├── README.md
├── templates/
│   └── docker.yml
├── components/
│   └── docker-build/
│       └── template.yml
├── examples/
│   ├── remote-project-include.yml
│   └── component-consumer.yml
└── DevOps_Reusable_Pipeline_Template_Session_88_Commands_CheatSheet.txt
```

## Main lab

The root `.gitlab-ci.yml` imports `templates/docker.yml` with `include:local`.
The real job extends the hidden `.docker_build_template` job.

```text
.gitlab-ci.yml
      |
      | include:local
      v
templates/docker.yml
      |
      | extends
      v
docker_build
```

The job builds an image tagged with `$CI_COMMIT_SHORT_SHA` and inspects the resulting image.

## Versioned remote template example

`examples/remote-project-include.yml` shows the central-template pattern:

```yaml
include:
  - project: 'root/ci-templates'
    ref: 'v1.0.0'
    file: '/templates/docker.yml'
```

Pinning `ref` to a release tag prevents a change on `main` from unexpectedly changing every consuming pipeline.

## CI/CD Component example

`components/docker-build/template.yml` defines reusable inputs with `spec:inputs`.

`examples/component-consumer.yml` shows how an application can consume a released component with a version such as `@1.0.0`.

## Runner requirement

The examples use the Runner tag:

```text
dev-shell
```

The Runner host must have Docker available to the GitLab Runner user.

## Topic

Chapter 10 — Advanced Pipelines  
Session 88 — Reusable Pipeline Template
