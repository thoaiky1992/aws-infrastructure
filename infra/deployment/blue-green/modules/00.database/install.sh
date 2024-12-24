#!/bin/bash
BLUE_DB_ARN=$(aws rds describe-db-instances \
    --db-instance-identifier v-1-0-0-postgres-app \
    --query "DBInstances[0].DBInstanceArn" \
    --region ap-southeast-1 --output text)
aws rds create-blue-green-deployment \
    --blue-green-deployment-name v-1-0-1-postgres-app \
    --source $BLUE_DB_ARN \
    --target-engine-version 16.3 \
    --target-db-parameter-group-name default.postgres16