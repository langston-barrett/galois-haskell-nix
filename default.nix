# This file overrides the Haskell package set with the given overrides.
{ pkgsOld ? import ./pinned-pkgs.nix { }
, compiler ? "ghc843"
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

  nixpkgs = builtins.fromJSON (builtins.readFile ./json/nixpkgs.json);

in import (pkgsOld.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) { inherit config; }
