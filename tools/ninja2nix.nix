# * ninja2nix
#
# This doesn't work.
{ pkgsOld ? import ../pinned-pkgs.nix { } }:

import ../default.nix {
  overrides = haskellPackagesNew: haskellPackagesOld:
    let mk = import ../mk.nix {
          inherit (pkgsOld) fetchFromGitHub;
          haskellPackages = haskellPackagesNew;
        };
        hlib = pkgsOld.haskell.lib;
        wrappers = import ../wrappers.nix { inherit hlib; };
    in {

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

    smallcheck-series = hlib.doJailbreak haskellPackagesOld.smallcheck-series;
    monad-mock = hlib.doJailbreak haskellPackagesOld.monad-mock;

    makefile = mk {
      name    = "makefile";
      owner   = "nmattia";
      json    = ./json/makefile.json;
    };
  };
}
