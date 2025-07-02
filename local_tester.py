import json
from local_func import lambda_handler

# Load the sample log
with open('sample_log.json') as f:
    sample_event = json.load(f)

# Run the Lambda function
lambda_handler(sample_event, None)
