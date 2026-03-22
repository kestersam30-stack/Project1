#!/bin/bash
IMAGE_NAME=kesterr15/devops-app

docker build -t $IMAGE_NAME:latest .
docker push $IMAGE_NAME:latest