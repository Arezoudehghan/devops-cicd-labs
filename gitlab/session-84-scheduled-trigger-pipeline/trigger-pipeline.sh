#!/usr/bin/env bash

curl --request POST \
  --form "token=$GITLAB_TRIGGER_TOKEN" \
  --form "ref=main" \
  --form "variables[DEPLOY_ENV]=staging" \
  --form "variables[APP_VERSION]=1.4.2" \
  "https://gitlab.example.com/api/v4/projects/PROJECT_ID/trigger/pipeline"
