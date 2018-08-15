#!/usr/bin/env bash

set -e

to_build=(
  # abcBridge
  # parameterized-utils
  # saw
  saw-core
  saw-core-aig
  saw-core-sbv
  crucible
  crucible-saw
  what4
  # cryptol-verifier
  elf-edit
  flexdis86
  binary-symbols
  galois-dwarf
  # jvm-verifier
  # llvm-verifier
  macaw-base
  # macaw-symbolic
  macaw-x86
  # macaw-x86-symbolic
)

# Write .travis.yml
echo "language: nix" > .travis.yml
echo "sudo: false" >> .travis.yml
echo "env:" >> .travis.yml
for pkg in ${to_build[*]}; do
  echo "  - PKG=${pkg}" >> .travis.yml
done
echo "script:" >> .travis.yml
echo '  - nix-build -A "haskellPackages.$PKG"' >> .travis.yml

for pkg in ${to_build[*]}; do
  echo nix-build -A "haskellPackages.${pkg}"
  nix-build -A "haskellPackages.${pkg}"
done
