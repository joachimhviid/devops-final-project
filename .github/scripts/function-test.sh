#!/bin/bash
docker compose up -d --build
# Check frontend is ready
for i in {1..30}; do
  if curl -s http://localhost:8080; then
    break
  fi
  sleep 1
done
# Check backend is ready
for i in {1..30}; do
  if curl -s http://localhost:9000; then
    break
  fi
  sleep 1
done

curl -f http://localhost:8080 || exit 1
curl -f http://localhost:9000 || exit 1

docker compose down
