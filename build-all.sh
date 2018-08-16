#!/usr/bin/env bash

set -e

to_build=(
  # abcBridge
  cryptol
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
  jvm-parser
  # jvm-verifier
  # llvm-verifier
  # llvm-pretty
  macaw-base
  # macaw-symbolic
  macaw-x86
  # macaw-x86-symbolic
)

# Write .travis.yml
echo "language: nix" > .travis.yml
echo "sudo: false" >> .travis.yml
echo "env:" >> .travis.yml
for ghc in 843 822; do
  for pkg in ${to_build[*]}; do
    echo "  - GHC=ghc${ghc} PKG=${pkg}" >> .travis.yml
  done
done
cat << EOF >> .travis.yml
script:
  - nix-build --arg compiler \"\$GHC\" -A "haskellPackages.\$PKG"
matrix:
  allow_failures:
    - env: GHC=ghc822
EOF

for pkg in ${to_build[*]}; do
  echo nix-build -A "haskellPackages.${pkg}"
  nix-build -A "haskellPackages.${pkg}"
done
