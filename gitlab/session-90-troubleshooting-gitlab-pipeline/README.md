# Session 90 — Troubleshooting GitLab Pipeline

This lab contains a working baseline pipeline and intentionally broken GitLab CI/CD examples for troubleshooting practice.

## Topics

- YAML Syntax Error
- Rule Error
- Stage Error
- `needs` Error
- Variable Error
- Permission Error
- Script Exit Code
- Pipeline Editor
- CI Lint
- Job Log
- Pipeline Graph

## Structure

```text
.
├── .gitlab-ci.yml
├── DevOps_Troubleshooting_GitLab_Pipeline_Session_90_Commands_CheatSheet.txt
└── examples
    ├── 01-yaml-syntax-error.yml
    ├── 02-stage-error.yml
    ├── 03-rule-error.yml
    ├── 04-needs-error.yml
    ├── 05-variable-error.yml
    ├── 06-permission-error.yml
    ├── 07-script-exit-code.yml
    └── 08-scenario-challenge.yml
```

The root `.gitlab-ci.yml` is the working baseline. The files under `examples/` are intentionally broken scenarios from the lesson and should be tested one at a time as `.gitlab-ci.yml`.
