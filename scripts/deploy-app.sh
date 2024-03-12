#!/bin/bash

sleep 10
/var/jenkins_home/kubectl apply -f https://raw.githubusercontent.com/ksatchit/hce-jenkins-integration-demo/main/k8s/cartservice.yaml

echo "waiting for deploy rollout to complete.."

/var/jenkins_home/kubectl rollout status deployment cartservice -n boutique

