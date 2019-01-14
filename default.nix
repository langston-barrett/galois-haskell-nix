# This file overrides the Haskell package set with the given overrides.
{ pkgsOld   ? import ./pinned-pkgs.nix { }
, compiler  ? "ghc844"
, overrides ? import ./overrides-galois.nix { inherit compiler; }
}:

let
  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1
    packageOverrides = pkgs: rec {
      haskellPackages =
        builtins.trace (builtins.concatStringsSep "\n" (builtins.attrNames pkgs.haskell.packages))
        pkgs.haskell.packages."${compiler}".override {
        overrides = overrides;
      };
    };
  };

  # Make sure this matches the one in pinned-pkgs.nix (TODO: put in separate file?)!
  nixpkgs = builtins.fromJSON (builtins.readFile ./json/nixpkgs-master.json);

in import (pkgsOld.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) { inherit config; }
