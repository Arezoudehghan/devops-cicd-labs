#!/usr/bin/env bash

set -e

BASE_URL="http://localhost:8088"

echo "Testing health endpoint..."
curl \
  --connect-timeout 3 \
  --max-time 5 \
  -fsS \
  "$BASE_URL/health"

echo
echo "Testing main endpoint..."
curl \
  --connect-timeout 3 \
  --max-time 5 \
  -fsS \
  "$BASE_URL/"

echo
echo "Smoke test passed"
