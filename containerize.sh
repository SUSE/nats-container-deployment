#!/bin/bash

set -ev

. .envrc

if [ ! -z "$DOCKER_HOST" ]; then
  echo "fissile build doesn't work with a remote docker host"
  exit 1
fi

[ ! -d "nats-release" ] && git clone --recurse-submodules https://github.com/cloudfoundry/nats-release

cp -a global-properties nats-release/jobs
pushd nats-release
  touch jobs/global-properties/monit
  bosh create-release --force
popd
docker pull "$FISSILE_STEMCELL"
fissile build packages
