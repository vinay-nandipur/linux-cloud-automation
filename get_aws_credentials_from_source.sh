#!/usr/bin/env bash

ACCESS_ID=$(cat ~/.aws/credentials | grep -i access_key_id)
ACCESS_ID=$(echo "${ACCESS_ID:18}")
printf '$ACCESS_ID'

SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep -i secret_access_key)
SECRET_ACCESS_KEY=$(echo "${SECRET_ACCESS_KEY:22}")
printf '$SECRET_ACCESS_KEY'

SESSION_TOKEN=$(cat ~/.aws/credentials | grep -i session_token)
SESSION_TOKEN=$(echo "${SESSION_TOKEN:18}")
printf '$SESSION_TOKEN'
