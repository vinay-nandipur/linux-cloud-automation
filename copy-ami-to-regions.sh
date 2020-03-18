#!/usr/bin/env bash

source="us-east-1"
ami_name="test-ami-name"
source_ami_id="ami-xxxxxxxxxxxxx"

for i in `cat /Users/user1/Documents/scripts/destination-regions.txt` ;

do

printf "Source AMI:$source_ami_id getting copied from $source to $i"

aws ec2 copy-image --source-image-id $source_ami_id --source-region $source --region $i --name $ami_name

done
