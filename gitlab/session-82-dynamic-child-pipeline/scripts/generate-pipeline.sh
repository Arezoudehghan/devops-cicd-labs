#!/bin/bash

set -e

OUTPUT="generated-child.yml"

echo "Generating dynamic child pipeline..."

cat > "$OUTPUT" <<'EOF'
stages:
  - test
  - build
EOF

if [ "$CI_COMMIT_BEFORE_SHA" = "0000000000000000000000000000000000000000" ]; then
    CHANGED_FILES=$(git ls-files)
else
    CHANGED_FILES=$(git diff --name-only "$CI_COMMIT_BEFORE_SHA" "$CI_COMMIT_SHA")
fi

echo "Changed files:"
echo "$CHANGED_FILES"

JOB_CREATED=false

if echo "$CHANGED_FILES" | grep -q "^backend/"; then

cat >> "$OUTPUT" <<'EOF'

backend_test:
  stage: test
  script:
    - echo "Running backend tests"

backend_build:
  stage: build
  script:
    - echo "Building backend"
EOF

JOB_CREATED=true

fi

if echo "$CHANGED_FILES" | grep -q "^frontend/"; then

cat >> "$OUTPUT" <<'EOF'

frontend_test:
  stage: test
  script:
    - echo "Running frontend tests"

frontend_build:
  stage: build
  script:
    - echo "Building frontend"
EOF

JOB_CREATED=true

fi

if [ "$JOB_CREATED" = false ]; then

cat >> "$OUTPUT" <<'EOF'

nothing_to_build:
  stage: test
  script:
    - echo "No application component changed"
EOF

fi

echo "Generated pipeline:"
cat "$OUTPUT"
