#!/bin/bash
IMAGE_NAME=kesterr15/devops-app

docker build -t $IMAGE_NAME:latest .
docker tag $IMAGE_NAME $DOCKER_USER/$IMAGE_NAME:latest
docker push $IMAGE_NAME:latest