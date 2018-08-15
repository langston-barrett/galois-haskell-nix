{ pkgs ? import <nixpkgs> { } }:

# https://github.com/Gabriel439/haskell-nix/tree/master/project0
# nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/NixOS/nixpkgs.git bbe31da148bb7003f22412ce1e5348a1d2bccef3 > nixpkgs.json"

let
  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

in import src { }
