#!/usr/bin/env bash

# Get the versions of packages that are checked out in the saw-script repo.
# This is more reliable than the master branches.

set -e

# https://bit.ly/2wM4MIG
args=( "$@" )

options=""
for pkg in ${args[*]}; do
  commit=$(cd ../saw-script; git ls-files -s "deps/$pkg" | awk '{print $2}')
  echo "nix-prefetch-git https://github.com/GaloisInc/$pkg $commit > json/saw/$pkg.json"
  nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/GaloisInc/$pkg $commit > json/saw/$pkg.json"
done
