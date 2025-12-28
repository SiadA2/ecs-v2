#!/bin/bash

# Usage: ./deploy.sh <image-uri> [environment]
IMAGE_URI=$1
ENVIRONMENT=${2:-prod}
REGION="eu-west-2"

if [ -z "$IMAGE_URI" ]; then
    echo "Usage: $0 <image-uri> [environment]"
    exit 1
fi

# Configuration
CLUSTER_NAME="url-cluster"
SERVICE_NAME="cb-service"
TASK_FAMILY="url-app-task"
APP_NAME="example"
DEPLOYMENT_GROUP_NAME="example"
CONTAINER_NAME="url-app"
CONTAINER_PORT=8080

echo "Creating new task definition for image: $IMAGE_URI"

# Get current task definition and update image
aws ecs describe-task-definition --task-definition $TASK_FAMILY --region $REGION \
    --query 'taskDefinition.{family:family,networkMode:networkMode,requiresCompatibilities:requiresCompatibilities,cpu:cpu,memory:memory,executionRoleArn:executionRoleArn,taskRoleArn:taskRoleArn,containerDefinitions:containerDefinitions}' \
    > current-task-def.json

# Update container image
jq --arg image "$IMAGE_URI" '.containerDefinitions[0].image = $image' current-task-def.json > new-task-def.json

# Register new task definition
echo "Registering new task definition..."
NEW_TASK_DEF_ARN=$(aws ecs register-task-definition --cli-input-json file://new-task-def.json --region $REGION --query 'taskDefinition.taskDefinitionArn' --output text)

echo "New task definition ARN: $NEW_TASK_DEF_ARN"

# Create appspec.yaml
cat > appspec.yaml << EOF
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: $NEW_TASK_DEF_ARN
        LoadBalancerInfo:
          ContainerName: $CONTAINER_NAME
          ContainerPort: $CONTAINER_PORT
EOF

# Create CodeDeploy deployment
echo "Creating CodeDeploy deployment..."
DEPLOYMENT_ID=$(aws deploy create-deployment \
    --application-name $APP_NAME \
    --deployment-group-name $DEPLOYMENT_GROUP_NAME \
    --revision revisionType=AppSpecContent,appSpecContent="$(cat appspec.yaml | jq -Rs .)" \
    --region $REGION \
    --query 'deploymentId' --output text)

echo "Deployment created with ID: $DEPLOYMENT_ID"

# Monitor deployment
echo "Monitoring deployment status..."
while true; do
    STATUS=$(aws deploy get-deployment --deployment-id $DEPLOYMENT_ID --region $REGION --query 'deploymentInfo.status' --output text)
    echo "Deployment status: $STATUS"
    
    if [ "$STATUS" != "InProgress" ]; then
        break
    fi
    
    sleep 30
done

echo "Deployment completed with status: $STATUS"

# Cleanup
rm -f current-task-def.json new-task-def.json appspec.yaml