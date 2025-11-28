#!/usr/bin/env bash
set -e
DEPLOY_DIR=~/meanapp-deploy

# Ensure directory exists
mkdir -p ${DEPLOY_DIR}
cd ${DEPLOY_DIR}

# Pull latest images
docker compose pull

# Bring up containers
docker compose up -d --remove-orphans --force-recreate

# Prune
docker image prune -af || true

echo "Deploy done: $(date)"

