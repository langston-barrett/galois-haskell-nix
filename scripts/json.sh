#!/usr/bin/env bash

set -e

# https://bit.ly/2wM4MIG
args=( "$@" )

for pkg in ${args[*]}; do

  # fix url
  owner="GaloisInc"
  if [[ $pkg == "llvm-pretty" ]]; then
    owner="elliottt"
  fi

  url="ssh://git@github.com/$owner/$pkg"
  echo "Fetching $url"
  nix-shell -p nix-prefetch-git --pure --run \
            "nix-prefetch-git \"$url\" > ./json/$pkg.json"
done
