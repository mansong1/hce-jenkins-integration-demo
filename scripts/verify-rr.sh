#!/bin/bash

set -e 

#curl -sL https://github.com/uditgaurav/hce-api-template/releases/download/0.1.0-saas/hce-api-linux-amd64 -o hce-api-saas
#curl -sL https://storage.googleapis.com/hce-api/hce-api-linux-amd64 -o hce-api-saas

#chmod +x hce-api-saas

resiliencyScore=$(hce-cli generate --api validate-resilience-score  --account-id=${ACCOUNT_ID} \
--project-id ${PROJECT_ID} --notifyID=$1  \
--api-key ${API_KEY} --file-name /var/tmp/hce-api.sh)

echo "${resiliencyScore}"
