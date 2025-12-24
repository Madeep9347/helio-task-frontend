#!/bin/bash
set -e

AWS_REGION=ap-south-1
AWS_ACCOUNT_ID=785186659004   # <-- your account id
ECR_REPO=frontend
CONTAINER_NAME=frontend

# CodeDeploy exposes deployment ID, not build number
# But CodePipeline passes the build number via revision
IMAGE_TAG=$(cat /opt/codedeploy-agent/deployment-root/deployment-instructions/* | grep -o '[0-9]\+' | head -1)

IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

echo "Starting backend container with image: $IMAGE_URI"

docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

docker pull $IMAGE_URI

docker run -d \
  --name $CONTAINER_NAME \
  -p 5000:5000 \
  $IMAGE_URI
