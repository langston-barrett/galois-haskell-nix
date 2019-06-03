# Use: nix-shell list-ghc-versions.nix
# Adapted from: https://github.com/pa-ba/compdata/compare/master...srdqty:srd-nix?expand=1
{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-19.03.tar.gz) { } }:
let compilers     = builtins.attrNames pkgs.haskell.packages;
    compilersText = builtins.concatStringsSep "\n" compilers;
in pkgs.stdenv.mkDerivation rec {
  name = "available-ghc-versions";

  shellHook = ''
    set -eu

    echo "Available ghc compiler versions:"
    echo -e "${compilersText}"

    exit
  '';
}
