#!/bin/bash

set -ev

. .envrc

if [ ! -z "$DOCKER_HOST" ]; then
  echo "fissile build doesn't work with a remote docker host"
  exit 1
fi

[ ! -d "bpm-release" ] && git clone --recurse-submodules https://github.com/cloudfoundry-incubator/bpm-release
[ ! -d "nats-release" ] && git clone --recurse-submodules https://github.com/cloudfoundry/nats-release
[ ! -d "scf-helper-release" ] && git clone --recurse-submodules https://github.com/SUSE/scf-helper-release

pushd bpm-release
  bosh create-release --force
popd

pushd nats-release
  bosh create-release --force
popd

pushd scf-helper-release
  cp $FISSILE_ROLE_MANIFEST ./src
  bosh create-release --force
popd


docker pull "$FISSILE_STEMCELL"
fissile build packages
