#!bin/bash

########################################################
# Ask for the website link and verify it exists
########################################################

echo "Hey! Enter the website link"
read URL

if curl --head --silent --fail $URL 2> /dev/null;
 then
    echo "Your request is processing...";
 else
    echo "This page does not exist. Please enter a valid URL";
    exit 1;
fi

export URL

########################################################
# Setup chrome and firefox selenium servers
########################################################

if lsof -Pi :4444 -sTCP:LISTEN -t >/dev/null; then
    echo "Selenium chrome already running";
else
    echo "Starting Selenium chrome";
    docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:3.141.59
fi &
if lsof -Pi :4443 -sTCP:LISTEN -t >/dev/null; then
    echo "Selenium firefox already running";
else
    echo "Starting Selenium firefox";
    docker run -d -p 4443:4444 -v /dev/shm:/dev/shm selenium/standalone-firefox:3.141.59
fi

########################################################
# Take screenshots
########################################################

# Ensure that node and appropriate node modules are installed
npm list selenium-webdriver || npm i selenium-webdriver
npm list async || npm i async

node ./lib/take-screenshots.js

########################################################
# Upload screenshots and get presigned urls
########################################################
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>

S3_BUCKET="browser-test-ss"
TIMESTAMP=$(date +%s)
EXPIRY_TIME=1800 #sec

function getPreSignedUrl {
    aws s3api put-object --bucket $S3_BUCKET --key $TIMESTAMP/$1.png  --body ./$1.png >/dev/null;
    SIGNED_URL=$(aws s3 presign s3://$S3_BUCKET/$TIMESTAMP/$1.png  --expires-in $EXPIRY_TIME --output text);
    echo "Presigned S3 url for $URL in $1: $SIGNED_URL"
    rm ./$1.png
}

getPreSignedUrl chrome;
getPreSignedUrl firefox;
