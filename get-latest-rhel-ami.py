#!/usr/bin/env python

import boto3
import sys

from dateutil import parser


region = "us-west-2"

def newest_image(list_of_images):
    latest = None

    for image in list_of_images:
        if not latest:
            latest = image
            continue

        if parser.parse(image['CreationDate']) > parser.parse(latest['CreationDate']):
            latest = image

    return latest

client = boto3.client('ec2', region_name=region)

filters = [ {
        'Name': 'name',
        'Values': ['RHEL-8.*']
    },{
        'Name': 'description',
        'Values': ['Provided by Red Hat, Inc*']
    },{
        'Name': 'architecture',
        'Values': ['x86_64']
    },{
        'Name': 'owner-id',
        'Values': ['309956199498']
    },{
        'Name': 'state',
        'Values': ['available']
    },{
        'Name': 'root-device-type',
        'Values': ['ebs']
    },{
        'Name': 'virtualization-type',
        'Values': ['hvm']
    } ]

response = client.describe_images(Owners=['309956199498'], Filters=filters)

source_image = newest_image(response['Images'])
id = (source_image['ImageId'])
print(id)
