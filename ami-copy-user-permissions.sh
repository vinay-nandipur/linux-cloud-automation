#!/usr/bin/env bash

printf "enter source image id:\t"

read src_img_id

printf "enter destination image id:\t"

read dst_img_id

aws ec2 describe-image-attribute --image-id $src_img_id --attribute launchPermission --query "LaunchPermissions[]" --output text > /tmp/UserIds

for i in `cat /tmp/UserIds` ; do aws ec2 modify-image-attribute --image-id $dst_img_id --launch-permission "{\"Add\": [{\"UserId\":\"$i\"}]}" ; done
