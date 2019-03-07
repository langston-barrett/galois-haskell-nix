{ pkgs ? import ../pinned-pkgs.nix { path = pkgsPath; }
, pkgsPath ? ../json/nixpkgs/master.json
}:

import ../generic-shell.nix {
  hpkgs = import ../tools/ninja2nix.nix { };
  name = "language-ninja";
  additionalHaskellInputs = hpkgs: with hpkgs; [
    QuickCheck
    doctest
    # ghc
    haddock-api
    haddock-library
    monad-mock
    quickcheck-instances
    tasty
    tasty-quickcheck
    tasty-hunit
    tasty-html
    # tasty-lens
    tasty-smallcheck
    template-haskell
    turtle
    versions
  ];
}
