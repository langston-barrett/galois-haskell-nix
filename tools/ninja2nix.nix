# * ninja2nix
#
# This doesn't work.
{ pkgsOld ? import ../pinned-pkgs.nix { } }:

import ../default.nix {
  overrides = haskellPackagesNew: haskellPackagesOld:
    let hlib = pkgsOld.haskell.lib;
        mk = import ../mk.nix {
          inherit (pkgsOld) fetchFromGitHub;
          inherit hlib;
          haskellPackages = haskellPackagesNew;
        };
        wrappers = import ../wrappers.nix { inherit hlib; };
        nixpkgs-master =
          import ../pinned-pkgs.nix { path = ../json/nixpkgs/master.json; };
    in {

    smallcheck-series = nixpkgs-master.haskell.packages.ghc844.smallcheck-series;
    # https://github.com/jdnavarro/smallcheck-lens/issues/6
    smallcheck-lens =
      hlib.doJailbreak (nixpkgs-master.haskell.packages.ghc844.smallcheck-lens);

    ninja2nix = mk {
      name    = "ninja2nix";
      owner   = "awakesecurity";
      json    = ./json/ninja2nix.json;
      wrapper = wrappers.jailbreakDefault;
    };

    cabal2ninja = mk {
      name    = "cabal2ninja";
      owner   = "awakesecurity";
      json    = ./json/cabal2ninja.json;
      wrapper = wrappers.jailbreakDefault;
    };

    monad-mock = hlib.doJailbreak haskellPackagesOld.monad-mock;

    makefile = mk {
      name    = "makefile";
      owner   = "nmattia";
      json    = ./json/makefile.json;
    };
  };
}
