# * Haskell code explorer
#
# Index a package with the [[https://github.com/alexwl/haskell-code-explorer][Haskell code explorer]]
#
# We can't do this as a derivation, because Cabal has too many network requests:
# https://github.com/haskell/cabal/issues/5363
#
# Be sure to use ~nix-shell --pure~!
{ pkgs  ? import ./pinned-pkgs.nix { }
, gpkgs ? import ./default.nix { }
, name  ? "crucible-llvm"
}:

let
  this  = gpkgs.haskellPackages.${name};
  ghcWP = gpkgs.haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
    # Cabal_2_2_0_1 # doesn't help?
  ] ++ this.buildInputs ++ this.propagatedBuildInputs);
  ghcPkgConf = ghcWP + "/lib/ghc-8.4.3/package.conf.d";
in with pkgs; stdenv.mkDerivation {
  name         = "${name}-code-exporer";
  buildInputs  = [
    ghcWP
    haskellPackages.cabal-install
    gpkgs.haskellPackages.haskell-code-explorer
  ];
  src          = if lib.inNixShell then null else this.src;
  shellHook    = ''
    # Save space and time be reusing the home directory
    root=/run/user/1000/code-explorer && mkdir -p "$root" && cd "$root"
    home=$root/home                   && mkdir -p "$home"
    dir=$root/${name}                 && mkdir -p "$dir"  && cd "$dir"
    export HOME=$home

    # Build and index the package
    cp -a ${this.src}/* "$dir"
    cabal update && cabal configure && cabal build
    haskell-code-indexer -p "$(pwd)" \
                         --dist dist/ \
                         --ghc "-package-db ${ghcPkgConf}"

    # Run the server
    haskell-code-server --package "$(pwd)"
  '';
  # installPhase = ''
  #   mkdir -p "$out"
  #   cp -a ./.haskell-code-explorer "$out"
  # '';
}
