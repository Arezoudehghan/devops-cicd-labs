# Session 45 — GitLab CI/CD Cache

This lab demonstrates the GitLab CI/CD `cache` feature and shows how cached files can be reused by later jobs and later pipelines to improve pipeline speed.

## Topics

- GitLab CI/CD Cache concept
- Cache versus Artifact
- Cache Hit and Cache Miss
- `cache:key`
- `cache:paths`
- `policy: pull`
- `policy: push`
- `policy: pull-push`
- Branch-specific cache keys with `$CI_COMMIT_REF_SLUG`
- Local cache behavior with a Shell Executor
- Cache invalidation and cache busting
- Dependency cache patterns for pip and npm
- Cache troubleshooting
- Runner disk usage checks

## Lab Environment

- Main host: DEV-1
- DEV-1 IP: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Default local Shell Runner cache root: `/home/gitlab-runner/cache`

## Lab Goal

The first pipeline run creates a cache file:

```text
.ci-cache/dependency.txt
```

The `prepare_cache` job uses:

```yaml
policy: pull-push
```

so it can restore an existing cache and upload an updated cache.

The `use_cache` job uses:

```yaml
policy: pull
```

so it restores the cache without uploading it again.

## Expected Flow

```text
Pipeline #1
prepare_cache
  -> CACHE MISS
  -> create .ci-cache/dependency.txt
  -> save cache

use_cache
  -> restore cache
  -> verify dependency.txt

Pipeline #2
prepare_cache
  -> restore previous cache
  -> CACHE HIT
```

## Cache vs Artifact

Use Cache for reusable data that can be downloaded or regenerated again, such as package-manager download caches.

Use Artifact for build outputs or files that later jobs must receive reliably.

A correct pipeline should still work if its Cache is deleted; it should only become slower.

## Verification

The pipeline verifies the restored cache with:

```bash
test -f .ci-cache/dependency.txt
```

The local Runner cache can be inspected with:

```bash
sudo find /home/gitlab-runner/cache -type f -name 'cache.zip' 2>/dev/null
```

## Files

- `.gitlab-ci.yml` — Session 45 cache demonstration pipeline
- `DevOps_Cache_Session_45_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
