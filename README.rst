==================
galois-haskell-nix
==================

To use these builds, import this package set in your Nix file and access its
``haskellPackages`` attribute::

  let
    galoisHaskell = import ../path/to/galois-haskell-nix/default.nix { };
  in stdenv.mkDerivation {
    buildInputs = [
      galoisHaskell.haskellPackages.crucible-jvm
    ];
  }


TODO
====

- Fix broken packages (see ``default.nix``)
- Test with multiple versions of GHC
- Test with multiple versions of nixpkgs
