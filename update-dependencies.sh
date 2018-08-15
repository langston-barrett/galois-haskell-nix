#!/usr/bin/env bash

set -e

for dep in saw-script parameterized-utils saw-core saw-core-aig saw-core-sbv saw-core-what4 crucible cryptol-verifier elf-edit flexdis86 dwarf jvm-verifier llvm-verifier macaw; do
  echo "Fetching $dep"
  nix-shell -p nix-prefetch-git --run \
    "nix-prefetch-git ssh://git@github.com/GaloisInc/$dep > $dep.json"
done
