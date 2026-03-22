#!/bin/bash
IMAGE_NAME=kesterr15/devops-app

docker pull $IMAGE_NAME:latest
docker stop app || true
docker rm app || true

docker run -d -p 80:80 --name app $IMAGE_NAME:latest