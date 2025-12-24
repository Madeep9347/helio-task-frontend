#!/bin/bash
set -e

AWS_REGION=ap-south-1
AWS_ACCOUNT_ID=785186659004   # <-- your account ID
ECR_REPO=frontend
CONTAINER_NAME=frontend

# Extract build number from CodeDeploy instructions
IMAGE_TAG=$(grep -o '[0-9]\+' /opt/codedeploy-agent/deployment-root/deployment-instructions/* | head -1)

IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

echo "Starting frontend container with image: $IMAGE_URI"

docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker pull $IMAGE_URI

docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  $IMAGE_URI
