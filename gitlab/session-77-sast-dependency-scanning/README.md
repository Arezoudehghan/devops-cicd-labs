# Session 77 — SAST and Dependency Scanning

Chapter: DevSecOps and Pipeline Security

This lesson introduces source-code security scanning, vulnerable dependency detection, CVE/CWE concepts, severity levels, security reports, and security quality gates in CI/CD.

## Topics

- SAST
- Vulnerable Dependency
- CVE
- CWE
- CVSS
- Severity
- Dependency Scanning
- Security Report
- Security Quality Gate
- False Positive
- Shift Left Security

## Security Coverage

```text
Application Security
│
├── Source Code
│      ↓
│     SAST
│
└── Dependencies
       ↓
 Dependency Scanning
```

SAST analyzes the application's source code for security weaknesses.

Dependency Scanning checks third-party packages and transitive dependencies for known vulnerabilities.

## SAST vs Dependency Scanning

```text
SAST
↓
Our Code

Dependency Scan
↓
Third-Party Code
```

Both controls are required because they detect different classes of security risk.

## CWE and CVE

- CWE describes a category or type of security weakness.
- CVE identifies a specific publicly known vulnerability.

Example weakness categories discussed in the lesson include Path Traversal and OS Command Injection.

## Severity and CVSS

Typical vulnerability severity levels:

```text
Critical
High
Medium
Low
Unknown
```

CVSS provides a numerical vulnerability score, commonly from 0.0 to 10.0.

A common mapping is:

```text
0.1 - 3.9   Low
4.0 - 6.9   Medium
7.0 - 8.9   High
9.0 - 10.0  Critical
```

## Security Reports

A scanner report can include:

- Vulnerability
- CVE
- CWE
- Package
- Installed Version
- Fixed Version
- Severity
- File
- Line
- Description
- Solution

The scan result should be machine-readable so the CI/CD pipeline can evaluate it.

## Security Quality Gate

A successful scanner execution does not mean the application has no vulnerabilities.

These are different states:

```text
Scan Failed
```

and:

```text
Scan Completed Successfully
+
Vulnerabilities Found
```

A Security Gate decides whether findings should block the pipeline.

Example policy from the lesson:

```text
Critical → Block Pipeline
High     → Block Pipeline
Medium   → Report
Low      → Report
```

The exact policy depends on the organization's risk appetite.

## GitLab SAST

The official GitLab SAST template shown in the lesson:

```yaml
include:
  - template: Jobs/SAST.gitlab-ci.yml
```

The lesson also notes that the standard GitLab SAST analyzers require a Linux Runner using Docker or Kubernetes Executor.

The current lab Runner uses:

```text
Executor: Shell
Tag: dev-shell
```

For a production design, a dedicated security Runner using Docker Executor can be added alongside the Shell Runner.

## GitLab Dependency Scanning

The newer GitLab Dependency Scanning template shown in the lesson:

```yaml
include:
  - template: Jobs/Dependency-Scanning.v2.gitlab-ci.yml
```

The lesson explains that the official GitLab Dependency Scanning feature depends on GitLab licensing, so the lab should not rely on it.

## Lab Tools

For the current GitLab CE lab:

```text
SAST
↓
Semgrep

Dependency Vulnerability Scan
↓
Trivy
```

Example Trivy filesystem scan:

```bash
trivy fs --scanners vuln .
```

High and Critical findings only:

```bash
trivy fs \
  --scanners vuln \
  --severity HIGH,CRITICAL \
  .
```

## Pipeline Flow

```text
Git Push
   ↓
Lint
   ↓
Unit Test
   ↓
Secret Detection
   ↓
SAST
   ↓
Dependency Scanning
   ↓
Security Gate
   ↓
Docker Build
   ↓
Push Nexus
   ↓
Deploy DEV-2
   ↓
Healthcheck
   ↓
Smoke Test
```

The `.gitlab-ci.yml` file in this session preserves the pipeline skeleton used in the lesson.

## Important Note

Finding a vulnerability does not automatically mean the scanner itself failed.

The scanner should produce a report, and the Security Gate or security policy should decide whether the pipeline can continue.
