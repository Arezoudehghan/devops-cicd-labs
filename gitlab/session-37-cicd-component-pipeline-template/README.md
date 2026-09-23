# Session 37 — CI/CD Component and Pipeline Template

This lab demonstrates reusable and versioned GitLab CI/CD configuration with CI/CD Components and shared Pipeline Templates.

## Topics

- GitLab CI/CD Components
- `include:component`
- `spec:inputs`
- Dynamic job names with component inputs
- Version pinning with `@1.0.0`
- Shared pipeline templates with `include:project`
- Docker image build through a reusable component
- Consumer-side image verification
- Component job-name collision avoidance
- Centralized CI/CD configuration

## Repository Layout

```text
session-37-cicd-component-pipeline-template/
├── README.md
├── DevOps_CI_CD_Component_Pipeline_Template_Session_37_Commands_CheatSheet.txt
├── ci-components/
│   ├── templates/
│   │   └── docker-build.yml
│   └── pipeline-templates/
│       └── basic-template.yml
└── component-consumer/
    ├── .gitlab-ci.yml
    ├── Dockerfile
    └── app.txt
```

## Lab Architecture

The GitLab lab uses two logical projects:

```text
devops-lab/ci-components
        |
        +-- templates/docker-build.yml
        +-- pipeline-templates/basic-template.yml
        |
        v
devops-lab/component-consumer
        |
        +-- .gitlab-ci.yml
        +-- Dockerfile
        +-- app.txt
```

## Component Flow

```text
include:component
       |
       v
docker-build@1.0.0
       |
       v
build-via-component
       |
       v
verify-image
```

## Lab Environment

- DEV-1: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Docker is available on the Runner host
- Component version used by the consumer: `1.0.0`

## Component Project

The reusable Docker build component is stored in:

```text
ci-components/templates/docker-build.yml
```

The shared non-component pipeline template is stored in:

```text
ci-components/pipeline-templates/basic-template.yml
```

## Consumer Project

The consumer pipeline imports the Docker build component with:

```yaml
include:
  - component: $CI_SERVER_FQDN/devops-lab/ci-components/docker-build@1.0.0
```

The consumer then verifies that the image tagged with `CI_COMMIT_SHORT_SHA` exists on the Shell Runner host.

## Key Design Pattern

Use `include:project` when you want to reuse a YAML file from another GitLab project.

Use `include:component` when you want a reusable, parameterized, and versioned CI/CD building block with a defined input interface.
