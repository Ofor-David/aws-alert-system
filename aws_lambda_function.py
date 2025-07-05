import json
import boto3
import gzip
import io

#List of suspicious events
# This list can be extended with more events as needed
# For example, you might want to add "DeleteUser", "CreateAccessKey", etc.
# depending on your security requirements.
sus_events = ["CreateUser", "AttachUserPolicy","StopLogging","PutBucketPolicy"]
sns_topic_arn = os.getenv('SNS_TOPIC_ARN')
def lambda_handler(event, context):
    s3 = boto3.client('s3')
    sns = boto3.client('sns')
    
    #Debugging
    if 'Records' not in event:
        print("No Records found in the event. Check your trigger source.")
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid event format: Missing Records.')
        }

    #Extract bucket name and object key from the s3 event trigger
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    object_key = event['Records'][0]['s3']['object']['key']

    print(f"New file detected: s3://{bucket_name}/{object_key}")

    #get the log file from s3
    response = s3.get_object(Bucket=bucket_name, Key=object_key)

    # Decompress GZIP file properly
    compressed_body = response['Body'].read()
    with gzip.GzipFile(fileobj=io.BytesIO(compressed_body)) as gzipfile:
        decompressed_data = gzipfile.read()

    # Check if the file is empty
    if not decompressed_data:
        print("Log file is empty. Skipping...")
        return {
            'statusCode': 200,
            'body': json.dumps('Empty log file. Skipped.')
        }

    try:
        log_data = json.loads(decompressed_data.decode('utf-8'))
    except json.JSONDecodeError as e:
        print(f"JSON Decode Error: {str(e)}")
        return {
        'statusCode': 400,
        'body': json.dumps('Invalid JSON format.')
        }

    sus_activities = []
    sent = False
    
    for record in log_data.get('Records', []):

        event_name = record.get('eventName')
        user = record.get('userIdentity', {}).get('userName', 'Unknown User')
        
        if event_name in sus_events:
            sus_activities.append({
                'eventName': event_name,
                'user': user,
                'eventTime': record.get('eventTime')
            })
            
            print(f"Suspicious activities detected")
            
            alert_message = "Suspicious activities detected:\n"
            for activity in sus_activities:
                detail = f"User: {activity['user']}, Event: {activity['eventName']}, Time: {activity['eventTime']}"
                print(detail)
                alert_message = detail
                
            if not sent:
                print("Sending alert via SNS")
                #send sns alert
                sns.publish(
                    TopicArn=sns_topic_arn,
                    Subject='AWS Suspicious activity detected',
                    Message=alert_message
                    #Message=json.dumps({'default': alert_message})
                )
                sent = True
        else:
            print(f"not suspicious")
    return { 
            'statusCode': 200,
            'body': json.dumps("scan complete")
    }
        