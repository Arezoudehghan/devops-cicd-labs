# Session 47 — Dependency Cache for Python, Node.js, Maven and Gradle

Chapter 5 — Dependency, Artifact and Cache

This lab demonstrates dependency caching in GitLab CI/CD for four common package ecosystems while using a Shell Executor.

## Topics

- Python `pip` cache with `PIP_CACHE_DIR`
- Node.js `npm` cache with `npm ci --cache .npm --prefer-offline`
- Maven local repository cache with `-Dmaven.repo.local`
- Gradle user home cache with `GRADLE_USER_HOME`
- File-based cache keys with dependency definition files
- `policy: pull-push`
- Cache versus Artifact
- Cache invalidation when dependency files change
- Shell Runner local cache behavior
- Troubleshooting cache restore and dependency downloads

## Lab Environment

- Main host: DEV-1
- DEV-1 IP: `192.168.94.90`
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`

## Dependency Cache Map

```text
Python   requirements.txt  -> .cache/pip/
Node.js  package-lock.json -> .npm/
Maven    pom.xml           -> .m2/repository/
Gradle   build.gradle      -> .gradle-user-home/
```

## Main Pipeline

The included `.gitlab-ci.yml` contains four independent jobs. Each job uses `rules:exists` so it runs only when the matching dependency definition file exists in the project.

For Gradle projects that use Kotlin DSL, replace `build.gradle` with `build.gradle.kts` in the relevant cache key and rule.

## Cache Design Rule

Cache the package manager's reusable download data, and build the cache key from the file that defines dependencies.

Build outputs such as `target/*.jar` should be stored as Artifacts rather than dependency Cache.

## Files

- `.gitlab-ci.yml` — Session 47 multi-ecosystem dependency-cache pipeline
- `DevOps_Dependency_Cache_Session_47_Commands_CheatSheet.txt` — all unique executable commands used in the lesson with beginner-friendly English explanations
