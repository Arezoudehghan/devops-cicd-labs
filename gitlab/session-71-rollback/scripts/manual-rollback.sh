#!/usr/bin/env bash

set -uo pipefail

STATE_DIR="/opt/myapp"

CURRENT_FILE="$STATE_DIR/current_version"
PREVIOUS_FILE="$STATE_DIR/previous_version"

CONTAINER_NAME="myapp"
IMAGE="$REGISTRY/$IMAGE_NAME"

HEALTH_URL="http://127.0.0.1:$APP_PORT/health"

if [ ! -f "$CURRENT_FILE" ]; then
    echo "ERROR: Current version is unknown."
    exit 30
fi

if [ ! -f "$PREVIOUS_FILE" ]; then
    echo "ERROR: Previous version does not exist."
    exit 31
fi

CURRENT_VERSION="$(cat "$CURRENT_FILE")"
ROLLBACK_VERSION="$(cat "$PREVIOUS_FILE")"

echo "Current version: $CURRENT_VERSION"
echo "Rollback version: $ROLLBACK_VERSION"

if ! docker pull "$IMAGE:$ROLLBACK_VERSION"; then
    echo "ERROR: Cannot pull rollback image."
    exit 32
fi

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

if ! docker run -d     --name "$CONTAINER_NAME"     --restart unless-stopped     -p "$APP_PORT:5000"     "$IMAGE:$ROLLBACK_VERSION"; then

    echo "ERROR: Rollback container failed to start."
    exit 33
fi

ROLLBACK_OK=0

for ATTEMPT in $(seq 1 10); do

    echo "Healthcheck attempt $ATTEMPT/10"

    if curl -fsS         --max-time 2         "$HEALTH_URL" >/dev/null; then

        ROLLBACK_OK=1
        break
    fi

    sleep 3
done

if [ "$ROLLBACK_OK" -ne 1 ]; then
    echo "ERROR: Rollback version is unhealthy."
    exit 34
fi

printf '%s\n' "$CURRENT_VERSION" > "$PREVIOUS_FILE"
printf '%s\n' "$ROLLBACK_VERSION" > "$CURRENT_FILE"

echo "Manual rollback successful."
echo "Production version: $ROLLBACK_VERSION"
