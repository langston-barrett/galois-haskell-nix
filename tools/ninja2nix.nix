# * ninja2nix
#
# This doesn't work.
{ pkgs ? import ../pinned-pkgs.nix { path = pkgsPath; }
, pkgsPath ? ../json/nixpkgs/master.json
}:

import ../default.nix {
  pkgsNew   = pkgsPath;
  compiler  = "ghc861";
  overrides = haskellPackagesNew: haskellPackagesOld:
    let hlib = pkgs.haskell.lib;
        mk = import ../mk.nix {
          inherit (pkgs) fetchFromGitHub;
          inherit hlib;
          haskellPackages = haskellPackagesNew;
        };
        wrappers = import ../wrappers.nix { inherit hlib; };
        # nixpkgs-master =
        #   import ../pinned-pkgs.nix {  };
    in {

    smallcheck-series = hlib.doJailbreak haskellPackagesOld.smallcheck-series;
    haddock-api = hlib.dontHaddock (hlib.doJailbreak haskellPackagesOld.haddock-api);
    # smallcheck-series = nixpkgs-master.haskell.packages.ghc843.smallcheck-series;
    # # https://github.com/jdnavarro/smallcheck-lens/issues/6
    # smallcheck-lens =
    #   hlib.doJailbreak haskellPackagesOld.smallcheck-lens;
    #   # hlib.doJailbreak (nixpkgs-master.haskell.packages.ghc843.smallcheck-lens);
    # tasty-lens =
    #   hlib.doJailbreak haskellPackagesOld.tasty-lens;
    #   # hlib.doJailbreak (nixpkgs-master.haskell.packages.ghc843.tasty-lens);

    aeson-pretty =
      hlib.doJailbreak (hlib.dontCheck (haskellPackagesOld.aeson-pretty));
    language-ninja =
      hlib.doJailbreak (hlib.dontCheck (haskellPackagesOld.language-ninja));
    # hlib.dontCheck haskellPackagesOld.language-ninja;

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
