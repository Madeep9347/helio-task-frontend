#!/bin/bash
set -e

CONTAINER_NAME=frontend

echo "Stopping frontend container..."

docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true
