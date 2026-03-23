#Dockerfile
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY build/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

This Dockerfile Use a ready-made Linux + Nginx image, put website files inside the container and create a new image and Start the web server when container runs.

#build.sh
#!/bin/bash
IMAGE_NAME=kesterr15/devops-app
docker pull $IMAGE_NAME:latest
docker stop app || true
docker rm app || true
docker run -d -p 80:80 --name app $IMAGE_NAME:latest

#deploy.sh - chmod +x deploy.sh
#!/bin/bash
IMAGE_NAME=kesterr15/devops-app
docker pull $IMAGE_NAME:latest (Pull latest image)
docker stop app || true        (Stop old container)
docker rm app || true
docker run -d -p 80:80 --name app $IMAGE_NAME:latest (Run new container)

#.gitignore
node_modules/
.env
*.log

#.dockerignore
.git
.gitignore
node_modules
*.log

EC2 setup
Install Docker, git, Jenkins and verify.
docker --version
git --version
Jenkins --version
Add Jenkins user to docker group - sudo usermod -aG docker jenkins

Open Jenkins via http://http://65.2.180.98:8080/ update docker credentials and install related plugins


Groovy
pipeline {
  agent any

  environment {
    DEV_IMAGE = "kesterr15/devops-app-dev"
    PROD_IMAGE = "kesterr15/devops-app-prod"
  }

  stages {

    stage('Clone') {
      steps {
        git branch: 'dev', url: 'https://github.com/kestersam30-stack/Project1.git'
      }
    }

    stage('Build') {
      steps {
        sh 'docker build -t $DEV_IMAGE:latest .'
      }
    }

    stage('Push Dev') {
      when {
        branch 'dev'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh 'docker push $DEV_IMAGE:latest'
        }
      }
    }

    stage('Push Prod') {
      when {
        branch 'master'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh 'docker build -t $PROD_IMAGE:latest .'
          sh 'docker push $PROD_IMAGE:latest'
        }
      }
    }

    stage('Deploy') {
      steps {
        sh 'chmod +x deploy.sh'
        sh 'bash deploy.sh'
      }
    }
  }
}

Note - This setup explicitly control which branch triggers which stage or which Docker image/repo is used.


EC2 setup - (EC2 crashed so changed instance type & increased volume. New ip is 13.232.248.55)
Install Grafana, node exporter & Prometheus


Monitored through Grafana and verified the container is running.
