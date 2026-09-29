# Session 86 — Monorepo Pipeline

This lab demonstrates a GitLab CI/CD pipeline for a monorepo.

## Topics

- Monorepo
- Path-based pipeline
- `rules:changes`
- Run jobs only for the changed service
- Parent/Child pipelines
- Shared dependency mapping

## Structure

```text
.
├── .gitlab-ci.yml
└── services
    ├── frontend
    │   ├── .gitlab-ci.yml
    │   └── app.txt
    ├── backend
    │   ├── .gitlab-ci.yml
    │   └── app.txt
    └── worker
        ├── .gitlab-ci.yml
        └── app.txt
└── shared
    └── common.txt
```

The parent pipeline uses `rules:changes` to trigger only the child pipeline for a changed service. Changes under `shared/**/*` are configured to trigger all three service pipelines.
