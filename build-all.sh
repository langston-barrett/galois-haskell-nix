#!/usr/bin/env bash

set -e

for pkg in saw-core saw-core-aig saw-core-sbv crucible crucible-jvm crucible-llvm crucible-saw what4 cryptol-verifier elf-edit flexdis86 binary-symbols galois-dwarf jvm-verifier llvm-verifier macaw-base macaw-symbolic macaw-x86 macaw-x86-symbolic; do
  nix-build -A "haskellPackages.${pkg}"
done
