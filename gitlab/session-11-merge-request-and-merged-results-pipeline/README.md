# Session 11 — Merge Request Pipeline and Merged Results Pipeline

This lab demonstrates the difference between a standard GitLab Merge Request Pipeline and a Merged Results Pipeline.

## Learning goals

- Run CI only for merge request events.
- Inspect merge request CI variables.
- Understand `CI_MERGE_REQUEST_EVENT_TYPE`.
- Show why testing only the source branch can miss integration problems.
- Simulate a merged-result validation on GitLab CE by merging the latest target branch into a temporary CI branch.
- Validate the final integrated configuration.

## Lab environment

- DEV-1: `192.168.94.90`
- GitLab CE
- GitLab Runner
- Runner tag: `dev-shell`
- Python 3

## Files

- `.gitlab-ci.yml` — Merge Request Pipeline plus merged-result simulation.
- `app.py` — Application default port.
- `deployment.conf` — Deployment port configuration.
- `validate_config.py` — Checks that both ports match.
- `DevOps_Merge_Request_and_Merged_Results_Pipeline_Session_11_Commands_CheatSheet.txt` — Commands used in the lesson with English explanations.

## Final validated state

```text
DEFAULT_PORT = 9090
PORT=9090
```

The source-branch validation and the simulated merged-result validation should both pass in the final state.

## Note

Native GitLab Merged Results Pipelines require GitLab Premium or Ultimate. This lab keeps the same learning objective on GitLab CE by explicitly fetching and merging the target branch inside a CI job.
