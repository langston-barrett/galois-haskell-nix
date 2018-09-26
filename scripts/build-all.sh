#!/usr/bin/env bash

set -e

# https://bit.ly/2wM4MIG
args=( "$@" )

options=""
for pkg in ${args[*]}; do
  options="${options} -A haskellPackages.${pkg}"
done
echo nix-build --no-sandbox $options
nix-build $options
