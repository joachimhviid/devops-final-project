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
  if curl -s http://localhost:9000/fortunes; then
    break
  fi
  sleep 1
done

docker compose down
