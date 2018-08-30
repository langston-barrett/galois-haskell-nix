==================
galois-haskell-nix
==================

This repository provides `Nix <https://nixos.org/nix>`_ builds of the
Haskell projects of `Galois, Inc <https://galois.com/>`_. To use these builds,
import this package set in your Nix file and access its ``haskellPackages``
attribute::

  let
    galoisHaskell = import ../path/to/galois-haskell-nix/default.nix { };
  in stdenv.mkDerivation {
    buildInputs = [
      galoisHaskell.haskellPackages.saw
    ];
  }

Hacking
=======

Layout
------
The JSON files contain the necessary information to perfectly reproduce builds
(git revisions and SHA256 hashes of those revisions). They can be updated using
the ``Makefile``, see below.

The various Nix files are for builds that needed customization beyond
``cabal2nix``. Code that was added by hand is clearly demarcated from
code that was generated.

When building SAW, it helps to pin the versions that SAW has as submodules, see
`the deps folder of saw-script
<https://github.com/GaloisInc/saw-script/tree/master/deps>`_ for the most recent
hashes.

``make`` targets
----------------

- ``build`` builds each package just as will be done in Travis. Due to the
  miracle of Nix, the builds will succeed in CI iff they succeed locally (modulo
  timeouts, which are very frequent).

- ``%.json`` will update the pinned version of a dependency. For example, the
  following would update the version of Macaw::

    rm macaw.json && make macaw.json

- ``travis`` regenerates ``.travis.yml``

- ``clean`` removes the symlinks that Nix makes when building.

TODO
====

- Test with multiple versions of nixpkgs
- Reorganize JSON files into a directory
