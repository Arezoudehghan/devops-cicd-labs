# Session 83 — Multi-project and Downstream Pipeline

This lab demonstrates a GitLab multi-project pipeline chain with upstream/downstream relationships and downstream status propagation.

## Pipeline Architecture

```text
Frontend Pipeline
        ↓
Backend Pipeline
        ↓
Deployment Pipeline
```

## Projects

### frontend-app

- Runs frontend test and build jobs.
- Passes frontend commit information to the backend pipeline.
- Triggers `cicd-lab/backend-app` on `main`.
- Uses `strategy: mirror` so downstream failure is reflected upstream.

### backend-app

- Runs backend test and build jobs.
- Receives `FRONTEND_IMAGE_TAG` from the frontend pipeline.
- Passes frontend and backend image tags to deployment.
- Triggers `cicd-lab/deployment-pipeline` only when the pipeline source is another pipeline.

### deployment-pipeline

- Validates the frontend and backend version variables.
- Runs the deployment job only for a multi-project downstream pipeline.
- Uses `DEV-2` as the lab deployment target in this session.

## Pipeline Dependency

```text
Frontend
   ↓  trigger + strategy: mirror
Backend
   ↓  trigger + strategy: mirror
Deployment
```

If the deployment pipeline fails, the backend trigger fails and the failure propagates back to the frontend pipeline.

## Files

- `frontend-app/.gitlab-ci.yml` — frontend upstream pipeline
- `backend-app/.gitlab-ci.yml` — backend downstream/upstream pipeline
- `deployment-pipeline/.gitlab-ci.yml` — final downstream deployment pipeline
- `DevOps_Multi_Project_Downstream_Pipeline_Session_83_Commands_CheatSheet.txt` — commands cheat sheet for this lesson
