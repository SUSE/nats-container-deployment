#!/bin/bash

set -ev

if [ ! -d output ]; then
  echo "Run ./containerize.sh first"
  exit 1
fi

. .envrc
[ -f .localrc ] && source .localrc

if [ -z "$DOCKER_ORG" ]; then
  if which minikube; then
    eval $(minikube docker-env)
  fi

  fissile build images --force
  fissile build helm --auth-type rbac
else
  fissile build images --docker-organization $DOCKER_ORG --force
  for i in `fissile show image --docker-organization $DOCKER_ORG`; do
    docker push $i
  done
  fissile build helm --docker-organization $DOCKER_ORG --auth-type rbac
fi

cat > "$FISSILE_OUTPUT_DIR/Chart.yaml" << EOF
apiVersion: 1
description: A Helm chart for NATS
name: my-nats
version: 1
EOF
helm install nats-chart --name my-nats --namespace my-nats --values vars.yml
