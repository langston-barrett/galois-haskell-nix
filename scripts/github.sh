#!/usr/bin/env bash

# Create a Nix file and pin JSON source for a github package

user=$1
pkg=$2

nix-shell \
  -p 'with import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { }; haskellPackages.cabal2nix' \
  --run "cabal2nix https://github.com/$user/$pkg.git > pkgs/$pkg.nix"

