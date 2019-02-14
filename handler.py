import os
import re
import json
import boto3
from botocore.vendored import requests

lam = boto3.client('lambda')

def classify_aircraft(url):

    aircraft = "None";
    result = lam.invoke(
        FunctionName=os.environ['DetectorName'],
        InvocationType='RequestResponse',
        Payload=json.dumps({ "url": url })
    )
    detected = json.loads(result['Payload'].read().decode('utf8'))

    if len(detected) == 1 and detected[0]['score'] > 99:
        result = lam.invoke(
            FunctionName=os.environ['ClassifierName'],
            InvocationType='RequestResponse',
            Payload=json.dumps({ "url": url})
        )
        aircraft = json.loads(result['Payload'].read().decode('utf8'))

    return aircraft

def lambda_handler(event, context):
    print(event)

    print("Aircraft detected: " + classify_aircraft(event['url']))