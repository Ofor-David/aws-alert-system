import json

#List of suspicious events
# This list can be extended with more events as needed
# For example, you might want to add "DeleteUser", "CreateAccessKey", etc.
# depending on your security requirements.
sus_events = ["CreateUser", "AttachUserPolicy","StopLogging","PutBucketPolicy"]

def lambda_handler(event, context):
    sus_activities = []
    
    for record in event.get('Records', []):
        event_name = record.get('eventName')
        user = record.get('userIdentity', {}).get('userName', 'Unknown User')
        
        if event_name in sus_events:
            sus_activities.append({
                'eventName': event_name,
                'user': user,
                'eventTime': record.get('eventTime'),
                
            })
            
        if sus_activities:
            print(f"Suspicious activities detected")
            for activity in sus_activities:
                print(f"User: {activity['user']}, Event: {activity['eventName']}, Time: {activity['eventTime']}")
            else:
                print("No suspicious activities detected") 
    return { 
            'statusCode': 200,
            'body': json.dumps(sus_activities)
    }
        