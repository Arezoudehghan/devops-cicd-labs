# Session 73 — Professional CI/CD Variables

Chapter 9: Variables, Secrets, and DevSecOps

This lab demonstrates professional GitLab CI/CD variable usage, variable scope, secret protection, file-type variables, environment scope, and variable precedence.

## Topics

- Project Variable
- Group Variable
- Instance Variable
- Pipeline Variable
- Predefined Variable
- Environment Scope
- Masked
- Hidden
- Protected
- File Type Variable
- Variable Precedence

## Lab Architecture

- DEV-1 — `192.168.94.90`
  - GitLab CE
  - GitLab Runner
  - Docker
  - Nexus
  - CI/CD tools
- DEV-2 — `192.168.94.91`
  - Docker deployment server
  - Prometheus
  - Grafana
  - Node Exporter
  - cAdvisor

Pipeline flow:

```text
GitLab CI/CD Variables
        |
        v
GitLab Runner
        |
        +--> Inspect predefined variables
        |
        +--> Test variable precedence
        |
        +--> Verify File Type variable
        |
        +--> Deploy to staging
        |
        +--> Manual production deployment
```

## Project Variables Used in the Lab

Create the following variables in GitLab Project CI/CD settings.

### LAB_PROJECT_VAR

```text
Key: LAB_PROJECT_VAR
Value: project-value
Type: Variable
Environment scope: *
Visibility: Visible
```

### DEPLOY_API_TOKEN for staging

```text
Key: DEPLOY_API_TOKEN
Value: a test token with at least 8 characters
Type: Variable
Environment scope: staging
Visibility: Masked
```

### DEPLOY_API_TOKEN for production

```text
Key: DEPLOY_API_TOKEN
Value: a different test token
Type: Variable
Environment scope: production
Visibility: Masked and hidden
Protected: Yes
```

### SSH_KNOWN_HOSTS

```text
Key: SSH_KNOWN_HOSTS
Type: File
Environment scope: *
Value: known_hosts file content
```

For a File Type variable, the environment variable contains the temporary file path, not the original file contents.

## Variable Scope

Use the smallest scope that satisfies the requirement:

```text
Project
  -> Group
  -> Instance
```

Examples:

```text
One project only
-> Project Variable

Several projects in one group
-> Group Variable

Entire self-managed GitLab instance
-> Instance Variable
```

## Environment Scope

The same variable key can use different values for different environments.

Example:

```text
DEPLOY_API_TOKEN
  staging scope    -> staging token
  production scope -> production token
```

The job must define an environment:

```yaml
environment:
  name: production
```

## Masked, Hidden, and Protected

These controls solve different problems:

```text
Masked
-> protects the value from direct exposure in job logs

Hidden
-> prevents the saved value from being revealed in the GitLab settings UI

Protected
-> makes the variable available only to pipelines running on protected branches or protected tags
```

A production secret can combine:

```text
Environment scope: production
Masked and hidden
Protected
```

These controls do not protect a secret from malicious pipeline code that is already authorized to access the variable.

## Predefined Variables Used

The lab uses GitLab predefined variables such as:

```text
CI_PROJECT_NAME
CI_COMMIT_BRANCH
CI_COMMIT_SHORT_SHA
CI_PIPELINE_ID
CI_DEFAULT_BRANCH
```

## Variable Precedence Lab

The pipeline defines:

```text
DEMO_PRIORITY=yaml-global
```

and then overrides it at job level:

```text
DEMO_PRIORITY=yaml-job
```

You can continue the test by defining the same key as a Project Variable and then as a Pipeline Variable.

For the levels used in this lesson:

```text
Pipeline Variable
>
Project Variable
>
Group Variable
>
Instance Variable
>
Job-level YAML Variable
>
Top-level YAML Variable
>
Predefined Variable
```

## File Type Variable Verification

The pipeline verifies that `SSH_KNOWN_HOSTS`:

- exists as a variable
- points to a regular file
- points to a non-empty file

It intentionally avoids printing the file contents.

## Production Safety

The production job is manual and only appears on the default branch.

The production token in this lab is also Protected, so the default branch must be configured as a Protected Branch for the variable to be available.

## Security Principle

Do not store passwords, API tokens, private keys, or other secrets directly in `.gitlab-ci.yml`.

Use CI/CD variable controls together with:

```text
Least Privilege
Protected Branches
Code Review
Environment Scope
Protected Variables
Masked / Hidden Variables
Secure Runners
Secret Management
```

## Main Principle

```text
Variable != Secret

A variable may contain normal configuration or sensitive data.

Use the smallest scope and the strongest appropriate controls for sensitive values.
```
