{ pkgs ? import <nixpkgs> { }
# Make sure this stays in sync with default.nix
, path ? ./json/nixpkgs-master.json
}:

# See this link for a tutorial:
# https://github.com/Gabriel439/haskell-nix/tree/master/project0

# nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/NixOS/nixpkgs.git bbe31da148bb7003f22412ce1e5348a1d2bccef3 > nixpkgs.json"

# > nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/NixOS/nixpkgs.git > json/nixpkgs-master.json"

let
  nixpkgs = builtins.fromJSON (builtins.readFile path);

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (nixpkgs) rev sha256;
  };

in import src { }
