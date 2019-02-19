{ pkgs ? import ./pinned-pkgs.nix { }
, name ? "crucible-llvm"
, additionalInputs ? pkgs: []
, additionalHaskellInputs ? pkgs: []
}:

let gpkgs = import ./local.nix { };
    this  = gpkgs.haskellPackages.${name};
in with pkgs; stdenv.mkDerivation {
  inherit name;
  src = if lib.inNixShell then null else lib.sourceFilesBySuffices ../. [ ".cabal" ".hs" ];
  buildInputs = [
    (gpkgs.haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
      ghcid

    ] ++ this.buildInputs
      ++ this.propagatedBuildInputs
      ++ additionalHaskellInputs gpkgs.haskellPackages))

    haskellPackages.cabal-install
    # haskellPackages.hlint
    # haskellPackages.importify

    git
    which
    zsh
  ] ++ additionalInputs gpkgs;
}
