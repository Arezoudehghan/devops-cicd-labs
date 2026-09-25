# Session 50 — Integration Test and Code Coverage

This lab demonstrates how to combine unit tests, integration tests, code coverage, coverage thresholds, test reports, and artifacts in a GitLab CI/CD quality gate.

## Topics

- Unit Test versus Integration Test
- Integration Test in CI/CD
- Code Coverage
- Coverage Threshold
- Failing a pipeline based on coverage
- JUnit Test Reports
- Cobertura Coverage Reports
- Storing test reports as GitLab artifacts
- Quality Gate design

## Lab Environment

- Main host: DEV-1
- GitLab Runner executor: Shell
- Runner tag: `dev-shell`
- Application: Flask
- Test framework: pytest
- Coverage tool: pytest-cov

## Pipeline Flow

```text
Unit Test
    |
    v
Integration Test
    |
    v
Coverage
    |
    v
Quality Gate
```

The coverage job enforces a minimum coverage threshold of 80 percent with `--cov-fail-under=80`.

## Project Structure

```text
.
├── .gitlab-ci.yml
├── app.py
├── requirements.txt
├── tests
│   ├── integration
│   │   └── test_api.py
│   └── unit
│       └── test_math.py
└── DevOps_Integration_Test_Code_Coverage_Session_50_Commands_CheatSheet.txt
```

## Reports

The pipeline generates:

- `reports/unit.xml` — Unit test JUnit report
- `reports/integration.xml` — Integration test JUnit report
- `reports/all-tests.xml` — Combined JUnit report from the coverage job
- `reports/coverage.xml` — Cobertura-compatible coverage report

Artifacts are kept for 7 days.

## Quality Gate

The quality gate is reached only when:

- Unit tests pass
- Integration tests pass
- Coverage is at least 80 percent

## Files

- `.gitlab-ci.yml` — GitLab CI/CD pipeline for tests, coverage, reports, artifacts, and quality gate
- `app.py` — Small Flask application used by the lab
- `requirements.txt` — Python dependencies
- `tests/unit/test_math.py` — Unit tests
- `tests/integration/test_api.py` — Integration tests
- `DevOps_Integration_Test_Code_Coverage_Session_50_Commands_CheatSheet.txt` — commands used in this lesson with beginner-friendly English explanations
