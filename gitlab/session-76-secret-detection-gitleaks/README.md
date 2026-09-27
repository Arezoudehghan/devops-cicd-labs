# Session 76 — Secret Detection with Gitleaks

Chapter 9: Variables, Secrets, and DevSecOps

This lab demonstrates how to detect leaked secrets in a Git repository and block a GitLab CI/CD pipeline with Gitleaks.

## Topics

- Secret Leakage
- Git History
- Gitleaks
- Repository Scanning
- Pipeline Failure
- False Positives
- Allowlists
- Security Gates

## Lab Architecture

- DEV-1 — `192.168.10.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - CI/CD tools
- Runner executor: Shell
- Runner tag: `dev-shell`

Pipeline flow:

```text
Commit
  -> Gitleaks security scan
  -> Test
  -> Build
```

If Gitleaks detects a secret:

```text
Commit
  -> Gitleaks
  -> Secret detected
  -> Job failed
  -> Pipeline blocked
```

## Why Git History Matters

Deleting a secret from the current file does not automatically remove it from previous commits.

```text
Delete current file != remove secret from Git history
```

This lab uses `gitleaks git` so the repository history is scanned.

## Gitleaks Version

The lab pins:

```text
ghcr.io/gitleaks/gitleaks:v8.30.1
```

Pinning the version makes CI behavior more predictable and reproducible.

## Gitleaks Configuration

The repository contains `.gitleaks.toml`.

It keeps the default Gitleaks rules and adds one safe lab-only pattern:

```text
LABSECRET-<24 alphanumeric characters>
```

Do not replace the lab value with a real password, API token, private key, cloud credential, or production secret.

## False Positive and Allowlist

The configuration includes a rule-specific allowlist for the `docs/` path.

To test the false-positive scenario, create `docs/example.env` locally with a fake value that matches the lab-only pattern. The training sample itself is intentionally not committed to this public repository.

This demonstrates how to handle a known false positive without disabling secret detection globally.

## Pipeline

The GitLab pipeline uses:

```yaml
variables:
  GIT_DEPTH: "0"
```

This requests the full Git history so Gitleaks can inspect previous commits instead of only a shallow checkout.

The security job runs before test and build jobs.

## Run a Manual Scan

From the repository root:

```bash
docker pull ghcr.io/gitleaks/gitleaks:v8.30.1

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/repo" \
  -w /repo \
  ghcr.io/gitleaks/gitleaks:v8.30.1 \
  git --redact --verbose .
```

A clean repository should pass.

## Safe Failure Test

To reproduce a failure locally, create a temporary file outside the allowlisted documentation path:

```bash
mkdir -p config
```

Create `config/app.env` locally with a fake value matching the lab-only `LABSECRET-` pattern.

Commit it only in a disposable training branch or disposable lab repository if you want to demonstrate Git-history detection.

Never use a real secret for this test.

## Current Files vs Git History

Current directory scan:

```bash
gitleaks dir .
```

Git history scan:

```bash
gitleaks git .
```

For CI/CD secret leakage detection, Git history scanning is important because a secret can remain in an older commit even after the current file is deleted.

## Security Gate

The Gitleaks job is intentionally blocking.

Do not hide a Gitleaks failure with shell logic, and do not set the security job to `allow_failure: true` when secret detection must block delivery.

## Incident Response

If a real secret is pushed:

1. Revoke or rotate the credential first.
2. Investigate where it may have been exposed.
3. Clean or rewrite Git history if required.
4. Store the replacement secret outside source control.

A leaked credential should be treated as compromised.

## Included Files

- `.gitlab-ci.yml` — GitLab security/test/build pipeline
- `.gitleaks.toml` — Gitleaks rules and documentation allowlist
- `DevOps_Gitleaks_Secret_Detection_Session_76_Commands_CheatSheet.txt` — session command cheat sheet
