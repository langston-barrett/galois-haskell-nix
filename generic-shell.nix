{ pkgs  ? import ./pinned-pkgs.nix { }
, hpkgs ? import ./local.nix { }
, name
, additionalInputs ? pkgs: []
, additionalHaskellInputs ? pkgs: []
}:

let this  = hpkgs.haskellPackages.${name};
in with pkgs; stdenv.mkDerivation {
  inherit name;
  src = if lib.inNixShell then null else lib.sourceFilesBySuffices ../. [ ".cabal" ".hs" ];
  shellHook = ''
    # 4mil KB = 4GB mem
    echo "try:"
    echo "ulimit -v 4000000"
  '';
  buildInputs = [
    (hpkgs.haskellPackages.ghcWithPackages (hpkgs': with hpkgs'; [
      ghcid
    ] ++ this.buildInputs
      ++ this.propagatedBuildInputs
      ++ additionalHaskellInputs hpkgs'))

    haskellPackages.cabal-install
    # haskellPackages.hlint
    # haskellPackages.importify

    firejail
    git
    which
    zsh
  ] ++ additionalInputs hpkgs;
}
