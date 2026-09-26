# Session 65 — SSH Deployment and SSH Key Management

Chapter 8: Deployment

This lab demonstrates secure SSH-based deployment preparation in GitLab CI/CD.

## Lab Architecture

- DEV-1: `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Shell Executor
  - Runner tag: `dev-shell`

- DEV-2: `192.168.94.91`
  - Deployment target
  - SSH server
  - Dedicated deployment user: `deploy`

## Main Topics

- SSH in CI/CD
- Public and private SSH keys
- Dedicated deploy user
- `authorized_keys`
- `known_hosts`
- Host verification
- GitLab File Type variables
- `ssh-agent`
- Least privilege

## Required GitLab CI/CD Variables

Create the following variables in GitLab:

- `SSH_PRIVATE_KEY`
  - Type: File
  - Value: dedicated CI/CD private key

- `SSH_KNOWN_HOSTS`
  - Type: File
  - Value: verified SSH host-key entries for DEV-2

The private key must not be committed to the repository.

## Pipeline Flow

```text
GitLab Pipeline
  -> Shell Runner on DEV-1
  -> start ssh-agent
  -> load SSH_PRIVATE_KEY
  -> install verified known_hosts
  -> SSH to deploy@192.168.94.91
  -> run remote verification commands
```

## Authentication Model

```text
Runner private key
  -> matches public key in
/home/deploy/.ssh/authorized_keys
```

## Host Verification Model

```text
DEV-2 host public key
  -> verified against
~/.ssh/known_hosts
```

## Security Principles

- Use a dedicated CI/CD SSH key instead of a personal key.
- Use a dedicated `deploy` account instead of direct root login.
- Keep the private key in GitLab CI/CD variables.
- Verify server host keys with `known_hosts`.
- Do not rely on `StrictHostKeyChecking=no` for production deployment.
- Apply least privilege to the deployment account.
- Rotate deployment keys when necessary.

## Lab Verification

The pipeline verifies the connection with:

```bash
ssh -o BatchMode=yes "$DEPLOY_USER@$DEPLOY_HOST" "whoami && hostname"
```

A successful run should authenticate as the `deploy` user and return the DEV-2 hostname without requesting a password.
