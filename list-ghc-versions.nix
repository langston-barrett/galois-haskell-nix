# Use: nix-shell list-ghc-versions.nix
{ pkgs ? import ./pinned-pkgs.nix { };
}:
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
