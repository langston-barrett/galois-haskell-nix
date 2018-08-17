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

Hacking
=======

This project pins specific versions of all of the projects involved (this
information is in the JSON files). These will quickly fall out of date, run
``update-dependencies.sh`` to upgrade them all.

The ``build-all.sh`` script builds each package just as will be done in Travis.
Due to the miracle of Nix, the builds will succeed in CI iff they succeed
locally.

TODO
====

- Fix broken packages (see ``default.nix``)
- Use a Makefile instead of ``build-all.sh``
- Test with multiple versions of GHC
- Test with multiple versions of nixpkgs
