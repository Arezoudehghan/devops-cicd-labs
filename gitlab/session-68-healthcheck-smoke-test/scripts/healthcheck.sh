#!/usr/bin/env bash

set -e

URL="http://localhost:8088/health"
MAX_RETRIES=10
SLEEP_SECONDS=3

for i in $(seq 1 "$MAX_RETRIES"); do

  echo "Healthcheck attempt: $i/$MAX_RETRIES"

  if curl \
      --connect-timeout 3 \
      --max-time 5 \
      -fsS \
      "$URL"; then

    echo
    echo "Application is healthy"
    exit 0

  fi

  sleep "$SLEEP_SECONDS"

done

echo "Application healthcheck failed"
exit 1
