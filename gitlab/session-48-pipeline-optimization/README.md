# Session 48 — Pipeline Optimization

This lab demonstrates practical GitLab CI/CD pipeline optimization by reducing unnecessary waiting and unnecessary artifact transfers.

## Topics

- Pipeline critical path
- Stage barriers versus DAG execution
- `needs`
- `needs:artifacts`
- Selective artifact downloads
- Cache versus Artifact
- `cache:key:files`
- `cache:policy`
- Fail-fast design
- `rules:changes`
- `GIT_DEPTH`
- `interruptible`
- Artifact size optimization

## Lab Environment

- DEV-1 IP: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- DEV-2 IP: `192.168.94.91`

## Lab Goal

The pipeline intentionally makes `build_docs` slower than `build_app`.

Without DAG optimization, `test_app` would wait for the whole build stage.

With `needs`, `test_app` starts as soon as `build_app` finishes and downloads only the artifact it requires.

## Optimized Flow

```text
build_app
   |
   v
test_app
   |
   v
package_app
   |
   v
deploy_app

build_docs -------------------->
```

## Artifact Optimization

`test_app` downloads the artifact from `build_app`:

```yaml
needs:
  - job: build_app
    artifacts: true
```

`package_app` needs the success state of `test_app`, but does not need artifacts from it:

```yaml
needs:
  - job: test_app
    artifacts: false
```

## Cache Pattern

For dependency caches such as pip packages, a content-based cache key can be used:

```yaml
cache:
  key:
    files:
      - requirements.txt
  paths:
    - .cache/pip/
```

Cache is an optimization and should not be required for pipeline correctness.

## Verification

The lab verifies artifact availability with:

```bash
test -f build/app.txt
test -f app-package.tar.gz
```

Runner cache size can be inspected with:

```bash
sudo du -sh /home/gitlab-runner/cache/
```

## Files

- `.gitlab-ci.yml` — optimized DAG pipeline for Session 48
- `DevOps_Pipeline_Optimization_Session_48_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
