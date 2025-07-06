# AWS Alert System

A serverless alerting system built to monitor AWS Infrastructure for suspicious activites.

## Features

- Monitors AWS resources for configurable suspicious activities and API calls for events like: CreateUser, DeleteUser, AttachUserPolicy, StopLogging, PutBucketPolicy, etc.
- Sends notifications via email.
- Easy deployment with Terraform

## AWS Services
- AWS CloudTrail
- AWS Lambda
- AWS Simple Storage Service (s3)
- AWS Identity and Access Management (IAM)
- AWS Simple Notification Service (SNS)


## Prerequisites

- AWS account with IAM permissions to deploy resources

## Configuration

1. Fork this repo and then clone it.
2. Enable Github Actions in your fork.
3. Edit `lambda_function.py` to define alert rules.
4. Inside the `terraform` folder, copy the contents of the `example_terraform_tfvars` file into a new `terraform.tfvars` file and fill in required variables.
5. Create github actions secrets for: 
      - `AWS_ACCESS_KEY_ID`
      - `AWS_SECRET_ACCESS_KEY`
      - `SNS_TOPIC_ARN`
      - `LAMBDA_CODE_BUCKET_NAME`( Must be thesame as specified in `terrform.tfvars` file).
6. Initialize and apply the Terraform configuration:
    ```bash
    terraform init
    terraform apply
    ``` 
    Note: If you run into an "object key not found error" then just commit and push a change for the `lambda_function.py` file to your repo and that would trigger the CICD workflow to upload the `lambda_function.zip` file to s3.
    Then run `terraform apply` again.
4. Confirm the sns subscription notification from the email sent to you.

## Usage

- Create a new iam user to test it out. 
Note: Alerts may take a short while before you get notified.

## Local Dev Testing
The `test_lambda.sh` script and the `sample_log.json` files were used for locally testing this project while it was in its early stages before cloud deployment.
The `sample_long.json` contains the format of what a suspicious event would look like in the cloudTrail log.
## Contributing

Contributions are welcome! Please open issues or submit pull requests.