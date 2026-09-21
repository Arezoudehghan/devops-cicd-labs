# Session 14 — GitLab Runner Installation on Linux

This lab covers installing GitLab Runner on Linux, understanding the Runner service and system user, verifying the installation, checking logs, and preparing a Shell executor host for Docker-based CI/CD jobs.

## Learning goals

- Understand the difference between installing and registering GitLab Runner.
- Install GitLab Runner from the official GitLab package repository.
- Verify the GitLab Runner binary, package, service, and startup state.
- Identify the `gitlab-runner` system user and home directory.
- Understand the purpose of `/etc/gitlab-runner/config.toml`.
- Inspect the systemd unit used to start GitLab Runner.
- Troubleshoot Runner service problems with `journalctl`.
- Verify whether the `gitlab-runner` user can access Docker.
- Understand the security impact of adding `gitlab-runner` to the `docker` group.

## Lab environment

- **DEV-1:** `192.168.94.90`
- **GitLab CE:** hosted on DEV-1
- **GitLab Runner:** installed on DEV-1 for the lab
- **Runner executor:** Shell
- **Runner tag:** `dev-shell`
- **Docker:** installed on DEV-1
- **Nexus:** hosted on DEV-1
- **DEV-2:** `192.168.94.91` for later deployment and monitoring labs

> In production, GitLab Runner should preferably run on a separate host from the GitLab server. DEV-1 combines them only because this is a two-VM training lab.

## Architecture

```text
Developer
    |
    | git push
    v
+-----------------------------+
| DEV-1                       |
| 192.168.94.90               |
|                             |
| GitLab CE                   |
| GitLab Runner               |
| Docker                      |
| Nexus                       |
+-----------------------------+
              |
              | SSH / Deploy
              v
+-----------------------------+
| DEV-2                       |
| 192.168.94.91               |
|                             |
| Docker                      |
| Application                 |
| Prometheus / Grafana        |
+-----------------------------+
```

## Install vs register

Installing GitLab Runner creates the Runner software, Linux service, and system user.

Registration is a separate step that connects the Runner to a GitLab instance and defines details such as the GitLab URL, authentication, and executor.

```text
Install
  |
  v
Runner software and service
  |
  v
Register
  |
  v
Runner connects to GitLab
  |
  v
Runner can receive jobs
```

## Pre-check

Check the operating system and architecture:

```bash
cat /etc/os-release
uname -m
hostnamectl
```

Check whether GitLab Runner is already installed:

```bash
command -v gitlab-runner
gitlab-runner --version
dpkg -l | grep gitlab-runner
systemctl status gitlab-runner --no-pager
```

If Runner is already installed on the host, do not reinstall it unnecessarily. Continue with the verification section.

## Fresh installation on Ubuntu/Debian

Refresh APT and install the required packages:

```bash
sudo apt update
sudo apt install -y curl ca-certificates
```

Check connectivity to the GitLab package service:

```bash
curl -I https://packages.gitlab.com
```

Download the official repository setup script:

```bash
cd /tmp
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" -o script.deb.sh
```

Inspect the script before executing it:

```bash
less /tmp/script.deb.sh
```

Run the repository setup script:

```bash
sudo bash /tmp/script.deb.sh
sudo apt update
```

Check the package candidate:

```bash
apt-cache policy gitlab-runner
```

Install GitLab Runner:

```bash
sudo apt install -y gitlab-runner
```

## Verify the installation

Check the Runner binary:

```bash
gitlab-runner --version
```

Check the service:

```bash
sudo systemctl status gitlab-runner --no-pager -l
systemctl is-active gitlab-runner
systemctl is-enabled gitlab-runner
```

Enable and start it if required:

```bash
sudo systemctl enable --now gitlab-runner
```

Check the running process:

```bash
ps -ef | grep '[g]itlab-runner'
```

Check the Runner user:

```bash
getent passwd gitlab-runner
id gitlab-runner
sudo ls -ld /home/gitlab-runner
```

## Runner configuration

The system-mode Runner configuration directory is:

```text
/etc/gitlab-runner/
```

After registration, the main configuration file is normally:

```text
/etc/gitlab-runner/config.toml
```

Inspect the configuration directory:

```bash
sudo ls -la /etc/gitlab-runner/
```

Inspect the systemd unit:

```bash
systemctl cat gitlab-runner
```

## Logs and service management

Show recent logs:

```bash
sudo journalctl -u gitlab-runner -n 50 --no-pager
```

Follow logs in real time:

```bash
sudo journalctl -u gitlab-runner -f
```

Restart, stop, or start the service:

```bash
sudo systemctl restart gitlab-runner
sudo systemctl stop gitlab-runner
sudo systemctl start gitlab-runner
```

## Shell executor and Docker access

A Shell executor that runs Docker commands must have permission to access the Docker daemon.

Test Docker access as the Runner user:

```bash
sudo -u gitlab-runner -H docker version
```

If the Runner user does not have Docker access, first inspect its groups:

```bash
id gitlab-runner
```

If approved by the host security policy, add the Runner user to the Docker group:

```bash
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner
```

Verify again:

```bash
id gitlab-runner
sudo -u gitlab-runner -H docker version
```

> Membership in the `docker` group provides highly privileged access to the host. Treat this as a security-sensitive configuration decision.

## Troubleshooting quick checks

Runner command not found:

```bash
command -v gitlab-runner
dpkg -l | grep gitlab-runner
```

Runner service unit not found:

```bash
dpkg -l | grep gitlab-runner
systemctl list-unit-files | grep gitlab-runner
```

Runner service failed:

```bash
sudo journalctl -u gitlab-runner -n 100 --no-pager
```

Package not found:

```bash
sudo apt update
apt-cache policy gitlab-runner
```

Docker permission problem:

```bash
id gitlab-runner
ls -l /var/run/docker.sock
sudo -u gitlab-runner -H docker version
```

## DEV-1 verification runbook

Because Runner is already installed on the current DEV-1 lab host, the practical task for this session is verification rather than reinstallation:

```bash
gitlab-runner --version
systemctl is-active gitlab-runner
systemctl is-enabled gitlab-runner
sudo systemctl status gitlab-runner --no-pager -l
id gitlab-runner
sudo ls -la /etc/gitlab-runner/
systemctl cat gitlab-runner
sudo journalctl -u gitlab-runner -n 30 --no-pager
sudo -u gitlab-runner -H docker version
```

## Lab files

- `README.md` — Session 14 lab notes and installation/verification workflow.
- `DevOps_GitLab_Runner_Linux_Installation_Session_14_Commands_CheatSheet.txt` — unique executable commands from this lesson with beginner-friendly English explanations.

## Key idea

```text
GitLab Runner installation
        !=
Runner registration
```

Installation prepares the Runner software and Linux service. Registration connects that Runner to GitLab so it can receive and execute jobs.
