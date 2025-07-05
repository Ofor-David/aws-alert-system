#!/bin/bash

set -e  # Stop the script if any command fails

export AWS_PAGER=""
LAMBDA_NAME="alert"
ZIP_FILE="localtest/lambda_function.zip"
HANDLER="lambda_function.lambda_handler"
ROLE_ARN="arn:aws:iam::000000000000:role/lambda-role"
FILE_TO_INVOKE="sample_log.json"
RESPONSE_FILE="localtest/response.json"

echo "👉 Zipping Lambda function..."
zip -r $ZIP_FILE lambda_function.py > /dev/null

echo "👉 Deleting existing Lambda function (if exists)..."
awslocal lambda delete-function --function-name $LAMBDA_NAME 2> /dev/null || true

echo "👉 Creating new Lambda function..."
awslocal lambda create-function \
    --function-name $LAMBDA_NAME \
    --runtime python3.13 \
    --handler $HANDLER \
    --role $ROLE_ARN \
    --zip-file fileb://$ZIP_FILE


echo "👉 Invoking Lambda function..."
awslocal lambda invoke --function-name $LAMBDA_NAME $RESPONSE_FILE > /dev/null

echo "👉 Lambda function output:"
cat $RESPONSE_FILE

echo "✅ Test completed."
