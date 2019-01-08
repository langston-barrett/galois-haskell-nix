# This file overrides the Haskell package set with the given overrides.

let path = ./json/nixpkgs-master.json; in

{ pkgsOld   ? import ./pinned-pkgs.nix { inherit path; }
, compiler  ? "ghc863"
, overrides ? import ./overrides-galois.nix { }
}:

let
  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskell.packages."${compiler}".override {
        overrides = overrides;
      };
    };
  };

  # Make sure this stays in sync with pinned-pkgs.nix
  nixpkgs = builtins.fromJSON (builtins.readFile path);

in import (pkgsOld.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) { inherit config; }
