# Session 24 — YAML Structure and Indentation

Chapter 4 — Mastering `.gitlab-ci.yml`

This lab focuses on YAML structure, mappings, sequences, indentation, and how these concepts apply to GitLab CI/CD configuration.

## Lab Environment

- **DEV-1:** `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Executor: `shell`

## Learning Goals

- Understand YAML key/value structure.
- Understand mappings and sequences.
- Read `.gitlab-ci.yml` as a parent/child tree.
- Use consistent two-space indentation in this course.
- Avoid tabs for YAML indentation.
- Understand how indentation changes GitLab CI/CD structure.
- Validate a pipeline before committing changes.
- Detect hidden tabs and formatting problems from the shell.

## YAML Structure

A simple mapping:

```yaml
server:
  name: dev-1
  ip: 192.168.94.90
  os: ubuntu
```

A sequence:

```yaml
stages:
  - build
  - test
  - deploy
```

The course convention is:

```text
0 spaces -> top-level key or job
2 spaces -> child property
4 spaces -> nested child or list item
```

YAML does not require exactly two spaces, but indentation must be consistent. Tabs must not be used for indentation.

## GitLab CI/CD Lab

The included `.gitlab-ci.yml` defines three stages:

```text
validate
   |
   v
build
   |
   v
test
```

The jobs are:

- `yaml_structure`
- `build_application`
- `test_application`

All jobs use the `dev-shell` Runner tag.

## Pipeline Structure

```text
.gitlab-ci.yml
|
+-- stages
|   +-- validate
|   +-- build
|   +-- test
|
+-- variables
|   +-- APP_NAME
|
+-- yaml_structure
|   +-- stage
|   +-- tags
|   +-- script
|
+-- build_application
|   +-- stage
|   +-- tags
|   +-- script
|
+-- test_application
    +-- stage
    +-- tags
    +-- script
```

## Important Indentation Examples

Correct:

```yaml
build_job:
  stage: build
  script:
    - echo "Building"
```

Incorrect:

```yaml
build_job:
  stage: build
script:
  - echo "Building"
```

In the incorrect example, `script` is no longer a child of `build_job`.

## Shell Verification

Enter the lab project directory:

```bash
cd ~/gitlab-labs/cicd-session24-yaml
```

Show the current directory:

```bash
pwd
```

List files including hidden files:

```bash
ls -la
```

Display the GitLab CI/CD file:

```bash
cat .gitlab-ci.yml
```

Display hidden and non-printing characters:

```bash
cat -A .gitlab-ci.yml
```

Search for tab characters:

```bash
grep -nP '\t' .gitlab-ci.yml
```

If the last command returns no matches, no tab characters were found.

## Key Troubleshooting Points

- A YAML parser error can be caused by invalid indentation.
- A GitLab CI/CD configuration error can happen even when the YAML itself is syntactically valid.
- `stage`, `tags`, and `script` must be correctly nested under their job.
- List items must use `-` at the correct indentation level.
- Use spaces, not tabs, for indentation.
- Commands that contain YAML-sensitive characters may need quoting.

## Artifact Behavior Note

The build job creates:

```text
build/result.txt
```

Jobs execute independently, so this file is not automatically available in a later job unless an artifact or another transfer mechanism is configured. In this lesson, the test job intentionally demonstrates that behavior without introducing artifacts yet.

## Files

- `.gitlab-ci.yml` — Session 24 YAML structure and indentation lab pipeline.
- `DevOps_YAML_Indentation_Session_24_Commands_CheatSheet.txt` — Commands from this lesson with beginner-friendly English explanations.
