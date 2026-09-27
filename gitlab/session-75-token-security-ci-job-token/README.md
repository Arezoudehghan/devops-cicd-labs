# Session 75 — Token Security and CI_JOB_TOKEN

Chapter 9: Variables, Secrets, and DevSecOps

This lesson focuses on choosing the correct GitLab token for CI/CD and automation while following least privilege.

## Topics

- `CI_JOB_TOKEN`
- Project Access Token
- Personal Access Token
- Deploy Token
- Trigger Token
- Token Scope
- Token Expiration
- Least Privilege

## Main Principle

Use the weakest credential that can perform the required task.

For GitLab CI/CD, first check whether `CI_JOB_TOKEN` can perform the operation before creating a longer-lived token.

## CI_JOB_TOKEN

GitLab creates `CI_JOB_TOKEN` automatically for a running CI/CD job.

The job does not need a custom CI/CD variable named `CI_JOB_TOKEN`.

Minimal pipeline used in this lesson:

```yaml
stages:
  - test

test-token:
  stage: test
  script:
    - echo "Job token exists"
```

Do not print the actual token value into job logs.

Unsafe example shown in the lesson:

```bash
echo "$CI_JOB_TOKEN"
```

## GitLab API Authentication

Example from the lesson:

```bash
curl \
  --header "JOB-TOKEN: $CI_JOB_TOKEN" \
  https://gitlab.example.com/api/v4/...
```

Prefer sending credentials in headers instead of placing them in URLs.

## Container Registry Authentication

Example from the lesson:

```bash
echo "$CI_REGISTRY_PASSWORD" |
docker login "$CI_REGISTRY" \
  -u "$CI_REGISTRY_USER" \
  --password-stdin
```

Image push example:

```bash
docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
```

The lesson also showed this less preferred form:

```bash
docker login "$CI_REGISTRY" \
  -u "$CI_REGISTRY_USER" \
  -p "$CI_REGISTRY_PASSWORD"
```

## Cross-Project Access

When Project A needs to access Project B with `CI_JOB_TOKEN`, configure the destination project's CI/CD Job Token Allowlist as required.

The triggering user must also have the required permission on the destination resource.

Use fine-grained permissions where appropriate.

## Token Selection

- `CI_JOB_TOKEN` — short-lived credential for GitLab CI/CD jobs.
- Project Access Token — project-specific automation credential.
- Personal Access Token — user-linked credential.
- Deploy Token — deployment, repository, registry, or package access.
- Trigger Token — pipeline trigger credential.

## Deploy Token Example

If a deployment server only needs to pull an image, prefer the smallest required scope:

```text
read_registry
```

Do not grant write access when only read access is required.

## Trigger Token Example

Example from the lesson:

```bash
curl --request POST \
  --form token="$TRIGGER_TOKEN" \
  --form ref="main" \
  "https://gitlab.example.com/api/v4/projects/123/trigger/pipeline"
```

Store the trigger token as a protected secret or CI/CD variable rather than committing it to the repository.

## Token Security Checklist

For every token, define:

- Owner
- Purpose
- Scope
- Expiration
- Rotation plan

Avoid:

- Broad PATs for simple pipeline tasks
- Long-lived credentials without a clear expiration policy
- Reusing one token across unrelated systems
- Committing tokens to the repository
- Printing secrets in job logs
- Passing tokens in URLs
- Granting write access when read access is sufficient

## Least Privilege

The goal is to minimize both permission and blast radius.

```text
Minimum Permission
+
Minimum Lifetime
+
Minimum Scope
+
No Secret in Logs
=
Safer Pipeline
```
