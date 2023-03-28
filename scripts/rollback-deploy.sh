#!/bin/bash

set -e

if [ "$1" -ge "${EXPECTED_RESILIENCE_SCORE}" ]; then
  kubectl rollout undo deployment/cartservice -n boutique
fi 
