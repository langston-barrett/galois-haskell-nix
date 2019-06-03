#!/usr/bin/env bash

# Create a Nix file and pin JSON source for a github package

user=$1
pkg=$2
subdir=${3:-.}

dst="$pkg"
if [[ $subdir != "." ]]; then
  dst="$pkg-$(basename $subdir)"
fi

nix-shell \
  -p 'with import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { }; haskellPackages.cabal2nix' \
  --run "cabal2nix --subpath $subdir --dont-fetch-submodules https://github.com/$user/$pkg.git > pkgs/$dst.nix"

