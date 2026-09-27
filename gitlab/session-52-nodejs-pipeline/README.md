# Session 52 — Node.js Pipeline Design

This lab demonstrates a GitLab CI/CD pipeline for a Node.js project using a Shell Runner tagged `dev-shell`.

## Topics

- `package.json`
- `npm install`
- `npm ci`
- dependency cache with `.npm/`
- lint
- test
- build
- artifact

## Pipeline Flow

```text
Git Push
   ↓
npm ci
   ↓
Lint
   ↓
Test
   ↓
Build
   ↓
dist/ Artifact
```

## Project Structure

```text
.
├── .gitlab-ci.yml
├── .gitignore
├── package.json
├── package-lock.json
├── src/
│   └── index.js
├── tests/
│   └── index.test.js
├── scripts/
│   └── build.js
└── DevOps_NodeJS_Pipeline_Session_52_Commands_CheatSheet.txt
```

## Local Verification

```bash
npm ci --cache .npm --prefer-offline
npm run lint
npm test
npm run build
```

The build job stores `dist/` as a GitLab artifact for 7 days. The cache key is derived from `package-lock.json`, so dependency cache invalidation follows lock-file changes.

The sample app intentionally uses Node.js built-in tooling so the lab stays self-contained while still demonstrating the CI/CD flow. The pipeline is ready for normal npm dependencies later without changing the cache design.
