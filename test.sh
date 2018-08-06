#!/bin/bash

set -v

sudo ip ro add \
  $(cat ~/.minikube/profiles/minikube/config.json | jq -r ".KubernetesConfig.ServiceCIDR") \
  via $(minikube ip)
curl -v $(kubectl --namespace my-nats get svc nats-public -o jsonpath="{.spec.clusterIP}"):4222
