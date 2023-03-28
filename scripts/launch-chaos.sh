#!/bin/bash
set -e 

echo ${API_KEY}
echo "*****"
curl --location 'https://app.harness.io/gateway/chaos/manager/api/query?accountIdentifier=${ACCOUNT_ID}' \
--header 'x-api-key: ${API_KEY}' \
--header 'Content-Type: application/json' \
--data '{"query":"mutation RunChaosExperiment(\n  $workflowID: String!,\n  $identifiers: IdentifiersRequest!\n) {\n  runChaosExperiment(\n    workflowID: $workflowID,\n    identifiers: $identifiers\n  ) {\n    notifyID\n  }\n}","variables":{"workflowID":"${WORKFLOW_ID}","identifiers":{"orgIdentifier":"default","accountIdentifier":"${ACCOUNT_ID}","projectIdentifier":"${PROJECT_ID}"}}}'
