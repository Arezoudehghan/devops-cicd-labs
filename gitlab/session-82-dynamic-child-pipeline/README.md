# Session 82 — Dynamic Child Pipeline

This lab demonstrates a GitLab Dynamic Child Pipeline that generates child-pipeline YAML at runtime and executes only the jobs required by the changed part of a monorepo.

## Pipeline Flow

```text
Git Push
   ↓
Parent Pipeline
   ↓
Detect Changed Files
   ↓
Generate generated-child.yml
   ↓
Save YAML as Artifact
   ↓
Trigger Dynamic Child Pipeline
   ↓
Run only required jobs
```

## Monorepo Scenario

- Changes under `backend/` generate backend test and build jobs.
- Changes under `frontend/` generate frontend test and build jobs.
- Changes outside both application directories generate the fallback `nothing_to_build` job.

## Main Concepts

- Runtime pipeline generation
- Generated YAML
- Dynamic jobs
- Artifact-based child pipeline configuration
- Monorepo change detection
- `strategy: mirror`

## Files

- `.gitlab-ci.yml` — parent pipeline that generates and triggers the child pipeline
- `scripts/generate-pipeline.sh` — runtime YAML generator
- `backend/app.py` — sample backend file used for change-detection testing
- `frontend/app.js` — sample frontend file used for change-detection testing
- `DevOps_Dynamic_Child_Pipeline_Session_82_Commands_CheatSheet.txt` — command cheat sheet for this lesson

## Lab Test

Backend change:

```bash
echo "# change" >> backend/app.py
git add .
git commit -m "change backend"
git push
```

Frontend change:

```bash
echo "// change" >> frontend/app.js
git add .
git commit -m "change frontend"
git push
```

The generator prints `generated-child.yml` in the job log so the runtime configuration can be inspected during troubleshooting.
