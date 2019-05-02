# This file overrides the Haskell package set with the given overrides.
{ pkgsOld   ? import ./pinned-pkgs.nix { }
, compiler  ? "ghc864"
, overrides ? import ./overrides-galois.nix { inherit compiler; }
, pkgsNew   ? ./json/nixpkgs/19.03.json
}:

let
  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1 # TODO: still necessary?
    allowBroken = true; # GHC 8.8.1, bytestring-handle
    packageOverrides = pkgs: rec {
      haskellPackages =
        # See available GHC versions by uncomenting this line:
        # builtins.trace (builtins.concatStringsSep "\n" (builtins.attrNames pkgs.haskell.packages))
        pkgs.haskell.packages."${compiler}".override {
        overrides = overrides;
      };
    };
  };

  # Make sure this matches the one in pinned-pkgs.nix (TODO: put in separate file?)!
  nixpkgs = builtins.fromJSON (builtins.readFile pkgsNew);

in import (pkgsOld.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) { inherit config; }
