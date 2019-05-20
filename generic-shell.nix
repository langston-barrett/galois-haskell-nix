{ pkgs  ? import ./pinned-pkgs.nix { }
, hpkgs ? import ./local.nix { }
, name
, additionalInputs ? pkgs: unstable: []
, additionalHaskellInputs ? pkgs: []
}:

let this  = hpkgs.haskellPackages.${name};
    unstable =
      import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { };
in with pkgs; pkgs.mkShell {
  shellHook = ''
    # 4mil KB = 4GB mem
    echo "try:"
    echo "ulimit -v 4000000"
  '';

  LANG = "en_US.utf8";
  LC_CTYPE = "en_US.utf8";
  LC_ALL = "en_US.utf8";
  buildInputs = [
    glibcLocales # https://github.com/commercialhaskell/stack/issues/793

    (hpkgs.haskellPackages.ghcWithPackages (hpkgs': with hpkgs'; [
    ] ++ this.buildInputs
      ++ this.propagatedBuildInputs
      ++ additionalHaskellInputs hpkgs'))

    # https://github.com/ndmitchell/ghcid/pull/236
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.hlint
    unstable.haskellPackages.apply-refact
    haskellPackages.cabal-install
    # haskellPackages.importify

    git
    which
    zsh
  ] ++ (additionalInputs hpkgs unstable);
}
