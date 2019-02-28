#!/usr/bin/env bash

set -e

# https://bit.ly/2wM4MIG
args=( "$@" )

for pkg in ${args[*]}; do

  # fix url
  owner="GaloisInc"
  if [[ $pkg == "llvm-pretty" ]]; then
    owner="elliottt"
  elif [[ $pkg == "sbv" || $pkg == "crackNum" ]]; then
    owner="LeventErkok"
    break # don't update this to master
  elif [[ $pkg == "constraints" ]]; then
    owner="ekmett"
    break # don't update this to master
  elif [[ $pkg == "itanium-abi" ]]; then
    owner="travitch"
  fi

  url="ssh://git@github.com/$owner/$pkg"
  echo "Fetching $url"
  nix-shell -p nix-prefetch-git --pure --run \
            "nix-prefetch-git \"$url\" > ./json/$pkg.json"
done
