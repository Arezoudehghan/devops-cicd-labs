#!/usr/bin/env bash

set -uo pipefail

STATE_DIR="/opt/myapp"
CURRENT_FILE="$STATE_DIR/current_version"
PREVIOUS_FILE="$STATE_DIR/previous_version"

CONTAINER_NAME="myapp"
IMAGE="$REGISTRY/$IMAGE_NAME"

HEALTH_URL="http://127.0.0.1:$APP_PORT/health"

mkdir -p "$STATE_DIR"

CURRENT_VERSION=""

if [ -f "$CURRENT_FILE" ]; then
    CURRENT_VERSION="$(cat "$CURRENT_FILE")"
fi

echo "Current stable version: ${CURRENT_VERSION:-none}"
echo "New version: $NEW_VERSION"

echo "Pulling new image..."

if ! docker pull "$IMAGE:$NEW_VERSION"; then
    echo "ERROR: Cannot pull new image."
    exit 10
fi

echo "Removing current container..."

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "Starting new version..."

if ! docker run -d     --name "$CONTAINER_NAME"     --restart unless-stopped     -p "$APP_PORT:5000"     "$IMAGE:$NEW_VERSION"; then

    echo "ERROR: New container could not start."
    exit 11
fi

echo "Checking application health..."

HEALTH_OK=0

if [ "${SIMULATE_HEALTH_FAILURE:-false}" = "true" ]; then

    echo "LAB: Healthcheck failure is being simulated."

else

    for ATTEMPT in $(seq 1 10); do

        echo "Healthcheck attempt $ATTEMPT/10"

        if curl -fsS             --max-time 2             "$HEALTH_URL" >/dev/null; then

            HEALTH_OK=1
            break
        fi

        sleep 3
    done

fi

if [ "$HEALTH_OK" -eq 1 ]; then

    echo "New version is healthy."

    if [ -n "$CURRENT_VERSION" ] &&
       [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then

        printf '%s\n' "$CURRENT_VERSION" > "$PREVIOUS_FILE"
    fi

    printf '%s\n' "$NEW_VERSION" > "$CURRENT_FILE"

    echo "Deployment successful."
    echo "Current version: $NEW_VERSION"

    exit 0
fi

echo "ERROR: New deployment failed healthcheck."

if [ -z "$CURRENT_VERSION" ]; then

    echo "ERROR: No previous stable version exists."
    docker logs "$CONTAINER_NAME" || true
    exit 20
fi

echo "Starting automatic rollback..."
echo "Rollback version: $CURRENT_VERSION"

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

if ! docker pull "$IMAGE:$CURRENT_VERSION"; then

    echo "CRITICAL: Cannot pull rollback image."
    exit 21
fi

if ! docker run -d     --name "$CONTAINER_NAME"     --restart unless-stopped     -p "$APP_PORT:5000"     "$IMAGE:$CURRENT_VERSION"; then

    echo "CRITICAL: Rollback container could not start."
    exit 22
fi

echo "Verifying rollback..."

ROLLBACK_OK=0

for ATTEMPT in $(seq 1 10); do

    echo "Rollback healthcheck $ATTEMPT/10"

    if curl -fsS         --max-time 2         "$HEALTH_URL" >/dev/null; then

        ROLLBACK_OK=1
        break
    fi

    sleep 3
done

if [ "$ROLLBACK_OK" -eq 1 ]; then

    printf '%s\n' "$CURRENT_VERSION" > "$CURRENT_FILE"

    echo "Rollback successful."
    echo "Production restored to: $CURRENT_VERSION"

    exit 1
fi

echo "CRITICAL: Rollback also failed."

docker logs "$CONTAINER_NAME" || true

exit 23
