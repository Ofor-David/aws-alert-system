# AWS Alert System

This project provides an AWS Lambda function that monitors AWS CloudTrail logs for suspicious activities and sends alerts via SNS when such events are detected.

## Features

- **Monitors CloudTrail logs** stored in S3 buckets.
- **Detects suspicious events** such as `CreateUser`, `AttachUserPolicy`, `StopLogging`, and `PutBucketPolicy`.
- **Sends alerts** to an SNS topic when suspicious activities are found.
- **Handles compressed (GZIP) CloudTrail log files**.

## How It Works

1. CloudTrail delivers logs to an S3 bucket.
2. The Lambda function is triggered by S3 `ObjectCreated` events.
3. The function decompresses and parses the log file.
4. If any suspicious events are found, an alert is sent to the configured SNS topic.

## Setup
1. **Enable cloudTrail Logging**
2. **Deploy the Lambda function** (`aws_lambda_func.py`) to AWS Lambda.
3. **Configure an S3 trigger** for the Lambda function on your CloudTrail log bucket.
4. **Set the SNS topic ARN** in the Lambda environment variable or directly in the code.
5. **Update the list of suspicious events** in the code as needed.

## Example Suspicious Events

- `CreateUser`
- `AttachUserPolicy`
- `StopLogging`
- `PutBucketPolicy`

You can extend this list in the `sus_events` variable in `aws_lambda_func.py`.

## Requirements

- Python 3.8+
- AWS Lambda permissions for S3, SNS, and CloudWatch Logs

## Customization

- Add or remove event names in the `sus_events` list to match your security requirements.
- Change the SNS topic ARN as needed.

## License

MIT License