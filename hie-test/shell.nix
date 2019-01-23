# * nix shell

{ pkgs ? import <nixpkgs> { } }:

let gpkgs = with pkgs; import ../default.nix { };
in with pkgs; stdenv.mkDerivation {
  name = "foo";
  src = null;

  buildInputs = [
    (gpkgs.haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
      ghcid
      # HIE needs have access to all the packages
      gpkgs.haskellPackages.hie
    ]))

    haskellPackages.cabal-install

    emacs
    zsh git which
  ];
}
