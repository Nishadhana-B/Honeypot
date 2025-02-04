import json
import boto3
import os

def lambda_handler(event, context):
    sns = boto3.client('sns')
    response = sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message="Honeypot alert! Potential attack detected.",
        Subject="Honeypot Alert"
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Alert Sent Successfully!')
    }
