# Session 89 — Central Organizational Pipeline

This lab demonstrates a central GitLab CI template consumed by an application project.

## Structure

- `templates/python.yml`: shared organizational Python pipeline template
- `project-a/.gitlab-ci.yml`: Project A consuming the versioned central template
- `DevOps_Central_Organizational_Pipeline_Session_89_Commands_CheatSheet.txt`: commands used in this lesson

## Versioning flow

The lesson uses versioned template references such as `v1.0.0` and `v1.1.0` instead of tracking `main` directly.
