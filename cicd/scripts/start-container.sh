#!/bin/bash
set -e

AWS_REGION=ap-south-1
AWS_ACCOUNT_ID=785186659004
ECR_REPO=frontend
CONTAINER_NAME=frontend

# Move to deployment root so artifacts are accessible
cd "$(dirname "$0")/../.."

# Load image tag passed from CodeBuild
source image.env

IMAGE_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

echo "Starting frontend container with image: $IMAGE_URI"

# Stop and remove old container if exists
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Pull and run image
docker pull $IMAGE_URI

docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  $IMAGE_URI
