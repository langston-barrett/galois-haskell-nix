{ pkgs ? import <nixpkgs> { }
, path ? ./json/nixpkgs.json
}:

# Why this revision of nixpkgs? One reason is that it is modern enough to have
# haskellPackages.json version 0.9.2, which add support for GHC 8.4.3.

# See this link for a tutorial:
# https://github.com/Gabriel439/haskell-nix/tree/master/project0

# nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/NixOS/nixpkgs.git bbe31da148bb7003f22412ce1e5348a1d2bccef3 > nixpkgs.json"

let
  nixpkgs = builtins.fromJSON (builtins.readFile path);

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

in import src { }
