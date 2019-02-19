# * haskell-ide-engine
#
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
    # nix-shell --pure -p nix-prefetch-git --run 'nix-prefetch-git https://github.com/haskell/haskell-ide-engine 0.5.0.0 > ../json/tools/hie.json'
    hie = mk {
      name  = "haskell-ide-engine";
      owner = "haskell";
      json  = ../json/tools/hie.json;
    };

    hie-plugin-api = mk {
      name    = "haskell-ide-engine";
      owner   = "haskell";
      json    = ../json/tools/hie.json;
      subdir  = "hie-plugin-api";
    };

    # For hie-plugin-api
    constrained-dynamic = wrappers.default haskellPackagesOld.constrained-dynamic;

    # hie/submodules: 53979f0
    HaRe = mk {
      name    = "HaRe";
      owner   = "alanz";
      json    = ../json/tools/hare.json;
      wrapper = x: hlib.dontHaddock (wrappers.jailbreakDefault x);
    };

    haskell-lsp = mk {
      name    = "haskell-lsp";
      owner   = "alanz";
      json    = ../json/tools/haskell-lsp.json;
      # wrapper = wrappers.jailbreakDefault;
    };

    haskell-lsp-types = mk {
      name    = "haskell-lsp";
      owner   = "alanz";
      json    = ../json/tools/haskell-lsp.json;
      subdir  = "haskell-lsp-types";
      # wrapper = wrappers.jailbreakDefault;
    };

    # Commit 3ccd528, See https://github.com/DanielG/ghc-mod/pull/937
    ghc-mod = mk {
      name    = "ghc-mod";
      owner   = "alanz";
      json    = ../json/tools/ghc-mod.json;
      wrapper = wrappers.jailbreakDefault;
    };

    ghc-mod-core = mk {
      name    = "ghc-mod";
      owner   = "alanz";
      json    = ../json/tools/ghc-mod.json;
      subdir  = "core";
      wrapper = wrappers.jailbreakDefault;
    };
  };
}
