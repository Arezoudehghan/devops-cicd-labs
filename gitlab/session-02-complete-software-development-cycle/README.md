# CI/CD Session 02 — Complete Software Development Cycle

This lab implements the complete flow:

Developer → Git → GitLab → GitLab Runner → Docker Build → Test → Deploy

## Lab architecture

- DEV-1: `192.168.94.90`
  - GitLab CE
  - GitLab Runner (Shell executor, tag: `dev-shell`)
  - Docker
- DEV-2: `192.168.94.91`
  - Docker deploy server
- Corporate proxy: `http://192.168.95.204:2081`
- Application host port: `8088`

## Project files

- `app.py`: Flask application
- `tests/test_app.py`: unit tests
- `Dockerfile`: production-style image with Docker HEALTHCHECK
- `.gitlab-ci.yml`: build, test, and deploy pipeline
- `scripts/deploy.sh`: validated remote deployment script
- `DevOps_CICD_Complete_Software_Development_Cycle_Session_2_Commands_CheatSheet.txt`: commands cheat sheet

## Required GitLab CI/CD variables

Create these in GitLab under **Settings → CI/CD → Variables**:

- `HTTP_PROXY`
- `HTTPS_PROXY`
- `NO_PROXY`
- `SSH_PRIVATE_KEY` — File variable
- `SSH_KNOWN_HOSTS` — File variable

Do not commit SSH private keys or other secrets to this repository.

## Proxy and SSL note

Docker daemon proxy, Docker build proxy, and container runtime proxy are separate concerns. The build passes proxy variables explicitly with `--build-arg`.

The Dockerfile uses `--trusted-host pypi.org` and `--trusted-host files.pythonhosted.org` as a lab workaround for the corporate SSL-inspection environment used in this session. In a production environment, install and trust the organization's CA certificate instead.

## Pipeline flow

1. Validate proxy variables.
2. Build the Docker image.
3. Save the image as `image.tar.gz`.
4. Run unit tests.
5. Run the container and verify Docker health.
6. Validate SSH File variables.
7. Transfer the artifact and deployment script to DEV-2.
8. Check for an existing container and port collision.
9. Deploy the exact image that passed testing.
10. Verify the final `/health` endpoint.
