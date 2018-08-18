#!/usr/bin/env bash

set -e

# This doesn't exactly match to_build, because multiple projects are in the same
# git repo.
#
# Additionally, abcBridge and llvm-pretty are handled manually.
to_fetch=(
  parameterized-utils
  saw-script
  saw-core
  saw-core-aig
  saw-core-sbv
  saw-core-what4
  crucible
  cryptol-verifier
  elf-edit
  flexdis86
  dwarf
  jvm-parser
  jvm-verifier
  llvm-verifier
  macaw
)

for dep in ${to_fetch[*]}; do
  echo "Fetching $dep"
  nix-shell -p nix-prefetch-git --run \
    "nix-prefetch-git ssh://git@github.com/GaloisInc/$dep > $dep.json"
done
