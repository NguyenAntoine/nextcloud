#!/bin/bash
# Update Docker images to latest versions

echo "Stopping containers..."
docker compose down

echo "Pulling latest images..."
docker compose pull

echo "Starting containers..."
docker compose up -d

echo "Waiting for services to start..."
sleep 10

echo "Checking container status..."
docker compose ps

echo "Update complete!"
