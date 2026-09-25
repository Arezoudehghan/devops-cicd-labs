# Session 46 — GitLab CI/CD Cache vs Artifact

This lab demonstrates the practical difference between GitLab CI/CD cache and artifacts.

## Core Rule

- Cache is for pipeline speed and reusable data.
- Artifacts are for job outputs that must be stored or passed to later jobs.
- A cache miss should make the pipeline slower, not incorrect.
- A missing required artifact can prevent a downstream job from continuing.

## Topics

- Cache versus artifact purpose
- Cache hit and cache miss
- Cache keys and cache invalidation
- `cache:policy`
- Artifact storage and `expire_in`
- Artifact transfer with `needs:artifacts`
- Branch and dependency-aware cache keys
- Correct use of cache for dependencies
- Correct use of artifacts for build outputs
- Troubleshooting missing cache and artifacts

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`

## Pipeline Flow

```text
cache_demo
    |
    v
build_package
    |
    v
verify_package
```

## Cache Flow

The `cache_demo` job stores:

```text
.cache/demo/dependency.txt
```

The first run should produce a cache miss and create the file. A later pipeline using the same cache key should restore it and produce a cache hit.

## Artifact Flow

The `build_package` job creates:

```text
dist/build-info.txt
dist/app-$CI_COMMIT_SHORT_SHA.tar.gz
```

The `verify_package` job downloads the artifact from `build_package` with:

```yaml
needs:
  - job: build_package
    artifacts: true
```

It then verifies that the archive exists and lists its contents.

## Files

- `.gitlab-ci.yml` — Session 46 cache-versus-artifact lab pipeline
- `DevOps_Cache_vs_Artifact_Session_46_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
