#!/usr/bin/env bash

set -Eeuo pipefail

: "${IMAGE_NAME:?IMAGE_NAME is required}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"
: "${CONTAINER_NAME:?CONTAINER_NAME is required}"
: "${DEPLOY_PORT:?DEPLOY_PORT is required}"
: "${ARCHIVE:?ARCHIVE is required}"

trap 'rm -f "$ARCHIVE" /tmp/deploy.sh' EXIT

echo "Loading Docker image..."

gunzip -c "$ARCHIVE" | docker load

if docker ps -a \
  --format '{{.Names}}' \
  | grep -Fxq "$CONTAINER_NAME"
then
  echo "Removing previous container: $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME"
fi

PORT_OWNER="$(
  docker ps \
    --filter "publish=${DEPLOY_PORT}" \
    --format '{{.Names}}' \
    | head -n 1
)"

if [ -n "$PORT_OWNER" ]; then
  echo "ERROR: Port ${DEPLOY_PORT} is already published by container: ${PORT_OWNER}" >&2
  exit 20
fi

docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  --env "APP_VERSION=$IMAGE_TAG" \
  --publish "${DEPLOY_PORT}:8080" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

for attempt in $(seq 1 20)
do
  HEALTH_STATUS="$(
    docker inspect \
      --format='{{.State.Health.Status}}' \
      "$CONTAINER_NAME"
  )"

  case "$HEALTH_STATUS" in
    healthy)
      echo "Deployment healthcheck passed."
      exit 0
      ;;
    unhealthy)
      echo "ERROR: Container is unhealthy." >&2
      docker logs "$CONTAINER_NAME"
      exit 21
      ;;
    starting)
      echo "Waiting for healthcheck (${attempt}/20)..."
      sleep 2
      ;;
    *)
      echo "ERROR: Unexpected health status: $HEALTH_STATUS" >&2
      docker logs "$CONTAINER_NAME" || true
      exit 22
      ;;
  esac
done

echo "ERROR: Healthcheck timed out." >&2
docker logs "$CONTAINER_NAME" || true
exit 23
