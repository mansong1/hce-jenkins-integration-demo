#!/bin/bash

curl -L https://github.com/uditgaurav/hce-api-template/releases/download/0.1.0-saas/hce-api-linux-amd64 -o hce-api-saas

chmod +x hce-api-saas

./hce-api-saas generate --api monitor-experiment --account-id=${ACCOUNT_ID} \
--project-id ${PROJECT_ID} --workflow-run-id ${WORKFLOW_RUN_ID} \
--api-key ${API_KEY} --file-name hce-api.sh --timeout="300"
