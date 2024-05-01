#! /usr/bin/env bash

# Define your SES credentials
ACCESS_KEY=""
SECRET_KEY=""

# Define the email information
FROM_EMAIL=""
TO_EMAIL="$1"
SUBJECT="Test Email from Bash"
BODY_TEXT="This is a test email sent from a Bash script using Amazon SES."
REGION="ap-southeast-1"

# AWS CLI command to send the email
aws ses send-email \
    --region $REGION \
    --from "$FROM_EMAIL" \
    --destination "ToAddresses=$TO_EMAIL" \
    --message "Subject={Data=$SUBJECT,Charset=utf-8},Body={Text={Data=$BODY_TEXT,Charset=utf-8}}" \
    --profile default

