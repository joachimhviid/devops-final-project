#!/bin/bash
[[ -z "${GIT_COMMIT}" ]] && Tag='local' || Tag="${GIT_COMMIT::8}" 
REPO="ghcr.io/$docker_username/"
echo "${REPO}"
docker build -t "${REPO}fortune-cookie-frontend:latest" -t "${REPO}fortune-cookie-frontend-app:1.0-$Tag" frontend/
docker build -t "${REPO}fortune-cookie-backend:latest" -t "${REPO}fortune-cookie-backend-app:1.0-$Tag" backend/
