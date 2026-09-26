# Session 70 — Preventing Concurrent Deployment

Chapter 8: Deployment

This lab demonstrates how to prevent two GitLab pipelines from deploying to the same production resource at the same time.

## Topics

- Concurrent Deployment
- Race Condition
- Resource Group
- Serialization
- Deployment Lock
- GitLab `resource_group`
- Deployment ordering and `process_mode`

## Lab Architecture

- DEV-1 — `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus Registry on port `8085`
- DEV-2 — `192.168.94.91`
  - Docker deployment server

Production target:

```text
GitLab Pipeline
  -> dev-shell Runner
  -> resource_group: production
  -> SSH to DEV-2
  -> replace myapp
  -> publish on port 8088
```

## The Problem

Without a deployment lock, two pipelines can reach production at nearly the same time:

```text
Pipeline A ----\
                -> Production
Pipeline B ----/
```

Both jobs may stop, remove, or start the same container. The final production state can then depend on timing instead of deployment intent.

This is a deployment race condition.

## The Solution

The production job uses:

```yaml
resource_group: production
```

Jobs using the same resource group are serialized. Only one deployment job can hold the production resource at a time.

```text
Pipeline A -> Deploy -> Finish
                         |
                         v
Pipeline B ------------> Deploy
```

## Pipeline Behavior

Build and test jobs in other pipelines can still run concurrently.

Only jobs that share the same resource group are serialized:

```text
Build A --------------------+
Test A ---------------------+--> deploy_production A
                                      |
                                      | production lock
                                      v
Build B --------------------+--> deploy_production B waits
Test B ---------------------+
```

## Lab Visibility Delay

The pipeline intentionally includes:

```bash
sleep 60
```

This makes it easier to create two pipelines and observe one production job holding the resource while the other waits.

Remove the artificial delay after the concurrency test if it is not needed.

## Production Deployment

The job deploys the image tagged with the current GitLab short commit SHA:

```text
192.168.94.90:8085/myapp:<CI_COMMIT_SHORT_SHA>
```

The deployment target is:

```text
deploy@192.168.94.91
```

The resulting container is:

```text
name: myapp
host port: 8088
container port: 8080
```

## Required Runner Access

The Shell Runner must already be able to SSH to:

```text
deploy@192.168.94.91
```

Do not commit SSH private keys, passwords, or production secrets to this repository.

## Test the Lock

Create two commits close together:

```bash
echo "change-1" >> test.txt
git add .
git commit -m "test concurrent deployment 1"
git push
```

Then immediately create another:

```bash
echo "change-2" >> test.txt
git add .
git commit -m "test concurrent deployment 2"
git push
```

Because the production job is manual, start the production deployment job in both pipelines.

Expected behavior:

```text
Pipeline A
  deploy_production = RUNNING

Pipeline B
  deploy_production = WAITING for production resource
```

After Pipeline A finishes, Pipeline B can acquire the same resource and run.

## Important Ordering Note

`resource_group` prevents concurrent access to the same deployment resource, but it does not by itself guarantee that the newest pipeline is the final deployed version.

GitLab resource groups also have a process mode that controls queue ordering.

The default process mode is:

```text
unordered
```

The lesson concepts also include:

```text
oldest_first
newest_first
newest_ready_first
```

Concurrency control and deployment ordering are related but separate production concerns.

## Manual Deployment and Locking

This lab combines:

```yaml
when: manual
resource_group: production
```

`when: manual` controls when the deployment is started.

`resource_group` controls how many deployment jobs can use the production resource at the same time.

## Main Principle

```text
Concurrent pipelines are useful for speed.

Concurrent writes to the same production resource are dangerous.

resource_group -> serialization -> one deployment at a time
```
