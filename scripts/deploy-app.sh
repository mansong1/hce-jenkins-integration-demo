#!/bin/bash

sleep 10
kubectl apply -f https://raw.githubusercontent.com/mansong1/hce-jenkins-integration-demo/main/k8s/cartservice.yaml

echo "waiting for deploy rollout to complete.."

kubectl rollout status deployment cartservice -n onlineboutique

