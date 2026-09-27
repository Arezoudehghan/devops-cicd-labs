# Session 74 — Secret Management in Pipeline

Chapter 9: Variables, Secrets and DevSecOps

This lab demonstrates secure handling of SSH private keys, registry passwords, tokens, API keys, and other secrets in a GitLab CI/CD pipeline.

## Topics

- SSH Private Key
- Password
- Token
- Registry Credential
- API Key
- Secret exposure in logs
- Dangerous echo/debug patterns
- Secret Rotation
- Least Privilege
- Secret Manager

## Lab Architecture

- DEV-1 — 192.168.10.90
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus Registry on port 8085
- DEV-2 — 192.168.10.91
  - Docker deployment server

Deployment flow:

~~~text
Developer
  -> GitLab on DEV-1
  -> dev-shell Runner
  -> CI/CD secret variables
  -> SSH to DEV-2
  -> Docker login to Nexus
  -> Pull image
  -> Deploy container
~~~

## Required CI/CD Variables

Non-secret values:

~~~text
DEPLOY_HOST=192.168.10.91
DEPLOY_USER=deploy
NEXUS_REGISTRY=192.168.10.90:8085
NEXUS_PULL_USER=<pull-only-user>
~~~

Sensitive values:

~~~text
NEXUS_PULL_PASSWORD
SSH_PRIVATE_KEY
SSH_KNOWN_HOSTS
~~~

Recommended GitLab configuration:

~~~text
NEXUS_PULL_PASSWORD
Type: Variable
Visibility: Masked and hidden
Protected: Yes
Environment scope: production

SSH_PRIVATE_KEY
Type: File
Protected: Yes
Environment scope: production

SSH_KNOWN_HOSTS
Type: File
Protected: Yes
Environment scope: production
~~~

Do not commit real passwords, tokens, private keys, or API keys to this repository.

## Secret Verification

The verify job checks that required secrets exist without printing their values:

~~~bash
test -n "$NEXUS_PULL_PASSWORD"
test -f "$SSH_PRIVATE_KEY"
test -f "$SSH_KNOWN_HOSTS"
~~~

Do not use echo, printenv, env, set, cat, tee, or shell tracing to inspect secret values in a production pipeline.

## SSH Private Key

SSH_PRIVATE_KEY should be stored as a GitLab File Type variable.

The job receives a temporary file path, not a value that should be printed.

The pipeline applies restrictive permissions:

~~~bash
chmod 600 "$SSH_PRIVATE_KEY"
~~~

The private key must never be committed or printed in the CI job log.

## SSH Host Verification

Generate trusted host-key data outside the production pipeline from a trusted environment:

~~~bash
ssh-keyscan 192.168.10.91
~~~

Store the verified result in SSH_KNOWN_HOSTS as a File Type variable.

The pipeline copies it to:

~~~text
~/.ssh/known_hosts
~~~

Avoid dynamically trusting an unknown host from inside the production job.

## Registry Authentication

The pipeline sends the registry password through standard input instead of using the Docker -p/--password command-line option:

~~~bash
printf '%s' "$NEXUS_PULL_PASSWORD" | docker login "$NEXUS_REGISTRY" -u "$NEXUS_PULL_USER" --password-stdin
~~~

In the deployment job, the same password stream is forwarded over SSH to docker login on DEV-2.

After the image is pulled, the pipeline logs out of the registry to reduce the time credentials remain stored on the deployment host.

## Least Privilege

Use separate credentials for separate purposes.

Recommended model:

~~~text
Build credential  -> push permission only when required
Deploy credential -> pull/read permission only
SSH deploy user   -> only permissions required for deployment
~~~

Do not give a deployment job full administrator or full API access when read-only registry access is enough.

## Secret Rotation

A safe rotation sequence is:

~~~text
1. Create new credential
2. Update GitLab secret
3. Run and verify the pipeline
4. Revoke the old credential
~~~

If the platform supports two active credentials, keep the old credential active only until the new credential is verified.

A leaked secret should be treated as compromised and rotated or revoked. Deleting a job log is not a replacement for credential rotation.

## Secret Manager

CI/CD Variables are practical for this lab.

Larger environments can use a dedicated secret manager such as HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, Google Cloud Secret Manager, or GitLab Secrets Manager.

Conceptual flow:

~~~text
GitLab Pipeline
  -> workload identity / OIDC
  -> Secret Manager policy
  -> retrieve authorized secret
  -> use secret only for the job
~~~

Secret managers can provide centralized policy, audit, expiration, rotation, versioning, and short-lived credentials.

## Security Rules

~~~text
Never hardcode a secret.
Never commit a secret.
Never print a secret.
Use protected and environment-scoped secrets.
Use least privilege.
Rotate and revoke credentials.
Prefer short-lived credentials when possible.
~~~
