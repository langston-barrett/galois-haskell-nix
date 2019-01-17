#!/usr/bin/env bash

set -e

# https://bit.ly/2wM4MIG
args=( "$@" )

for pkg in "${args[@]}"; do
  if nix-build -A "haskellPackages.$pkg"; then
    sed -i "s/- $pkg: ./- $pkg: ☑/" README.org
  else
    sed -i "s/- $pkg: ./- $pkg: ☐/" README.org
  fi
done
