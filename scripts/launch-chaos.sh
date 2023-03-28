#!/bin/bash

set -ex

curl -L https://github.com/uditgaurav/hce-api-template/releases/download/0.1.0-saas/hce-api-linux-amd64 -o hce-api-saas

chmod +x hce-api-saas

output=$(./hce-api-saas generate --api launch-experiment --account-id=${ACCOUNT_ID} \
--project-id ${PROJECT_ID} --workflow-id ${WORKFLOW_ID} \
--api-key ${API_KEY} --file-name hce-api.sh | jq -r '.data.runChaosExperiment.notifyID')


./hce-api-saas generate --api monitor-experiment --account-id=${ACCOUNT_ID} \
--project-id ${PROJECT_ID} --notifyID=$output  \
--api-key ${API_KEY} --file-name hce-api.sh --timeout="500"

resiliencyScore=$(./hce-api-saas generate --api validate-resilience-score  --account-id=${ACCOUNT_ID} \
--project-id ${PROJECT_ID} --notifyID=$output  \
--api-key ${API_KEY} --file-name hce-api.sh)

echo "The Resiliency Score is: ${resiliencyScore}"
