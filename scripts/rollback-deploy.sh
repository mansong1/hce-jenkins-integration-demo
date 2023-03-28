#!/bin/bash

set -e

if [[ "$1" -lt "${EXPECTED_RESILIENCE_SCORE}" ]]; then
  kubectl rollout undo deployment/cartservice -n boutique
fi 
