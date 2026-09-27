# Session 79 — Dockerfile and Infrastructure as Code Scanning

This lab adds pre-build security checks for Dockerfiles and Infrastructure as Code with Trivy.

## Topics

- Misconfiguration
- Dockerfile Scan
- IaC Scan
- Trivy Config
- Security Best Practice
- Privileged Container
- Root User
- Exposed Secrets
- Least Privilege
- Shift Left Security

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: dev-shell
- Security scanner: Trivy

## Security Flow

~~~text
Developer
    |
    v
Git Push
    |
    v
Test
    |
    v
Dockerfile / IaC Scan
    |
    v
Security Gate
    |
    v
Docker Build
~~~

The security gate is designed to stop HIGH or CRITICAL configuration findings before the Docker image is built.

## Project Structure

~~~text
.
├── .gitlab-ci.yml
├── Dockerfile
├── app.py
├── requirements.txt
├── k8s
│   └── deployment.yaml
└── DevOps_Dockerfile_IaC_Scanning_Session_79_Commands_CheatSheet.txt
~~~

## Dockerfile Security

The runtime container uses a dedicated non-root account:

~~~dockerfile
RUN groupadd --system appgroup && \
    useradd --system --gid appgroup appuser

COPY --chown=appuser:appgroup . .

USER appuser
~~~

This follows the least-privilege principle and avoids running the application as root.

## Kubernetes Security Context

The Kubernetes manifest disables privileged execution and privilege escalation, requires a non-root UID, makes the root filesystem read-only, and drops all Linux capabilities.

~~~yaml
securityContext:
  privileged: false
  runAsNonRoot: true
  runAsUser: 10001
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
~~~

## Trivy Configuration Scan

Scan supported Dockerfile and IaC configuration from the project directory:

~~~bash
trivy config .
~~~

Filter to HIGH and CRITICAL findings and fail the job when matches are detected:

~~~bash
trivy config \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  .
~~~

## Repository Security Scan

Scan the repository for misconfiguration and exposed secrets:

~~~bash
trivy fs --scanners misconfig,secret .
~~~

A broader filesystem scan can also include supported dependency vulnerabilities:

~~~bash
trivy fs --scanners vuln,misconfig,secret .
~~~

## GitLab CI Security Gates

The pipeline contains two security jobs:

- `iac_scan` — configuration scan for HIGH and CRITICAL findings
- `security_scan` — filesystem misconfiguration and secret scan

Both jobs use the `dev-shell` Runner tag.

## Files

- `.gitlab-ci.yml` — pre-build Trivy security gates from the lesson
- `Dockerfile` — hardened non-root Python container
- `app.py` — minimal Python application used by the lab image
- `requirements.txt` — dependency file used by the Dockerfile
- `k8s/deployment.yaml` — hardened Kubernetes Deployment security context
- `DevOps_Dockerfile_IaC_Scanning_Session_79_Commands_CheatSheet.txt` — commands and configuration entries from this lesson with beginner-friendly English explanations
