#!/bin/bash

IMAGE="kesterr15/devops-app-dev:latest"

echo "Stopping old container..."
docker stop app || true

echo "Removing old container..."
docker rm app || true

echo "Running new container..."
docker run -d -p 80:80 --name app $IMAGE