{ pkgs ? import ./pinned-pkgs.nix { }
, name ? "crucible-llvm"
}:

let gpkgs = import ./local.nix { };
    this  = gpkgs.haskellPackages.${name};
in with pkgs; stdenv.mkDerivation {
  inherit name;
  src = if lib.inNixShell then null else lib.sourceFilesBySuffices ../. [ ".cabal" ".hs" ];
  buildInputs = [
    (gpkgs.haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
      ghcid
    ] ++ this.buildInputs ++ this.propagatedBuildInputs))

    haskellPackages.cabal-install
    # haskellPackages.importify

    git
    which
    zsh
  ];
}
