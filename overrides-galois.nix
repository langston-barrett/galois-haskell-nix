# Overrides to the default Haskell package set for most Galois packages
{ pkgsOld  ? import ./pinned-pkgs.nix { }
, compiler # ? "ghc843"
, sourceType ? "master"  # "master" or "saw"
, buildType  ? "fast" # "good" (optimized) or "fast" (unoptimized)
}:

haskellPackagesNew: haskellPackagesOld:

#################################################################
# ** Utilities and functions

let
  hlib = pkgsOld.haskell.lib;

  # Find the appropriate JSON source spec
  sources  = import ./sources.nix { inherit sourceType; };
  wrappers = import ./wrappers.nix { inherit hlib buildType; };
  mk = import ./mk.nix {
    inherit (pkgsOld) fetchFromGitHub;
    inherit hlib;
    haskellPackages = haskellPackagesNew;
  };

  # For packages that have different behavior for different GHC versions
  switchGHC = arg: arg."${compiler}" or arg.otherwise;

  # Jailbreak a package for a specific version of GHC
  jailbreakOnGHC = ver: pkg: switchGHC {
    "${ver}"  = wrappers.jailbreak pkg;
    otherwise = pkg;
  };

  # ABC has a tricky build...
  abc    = pkgsOld.callPackage ./abc.nix { };
  addABC = drv: drv.overrideDerivation (oldAttrs: {
      buildPhase = ''
        export NIX_LDFLAGS+=" -L${abc} -L${abc}/lib"
        ${oldAttrs.buildPhase}
      '';
      librarySystemDepends = [ abc ];
  });

  withSubdirs = pname: f: suffix: mk {
    json   = sources.${pname};
    # name   = pname + maybeSuffix suffix; # TODO: use this
    name   = pname + "-" + suffix;
    repo   = pname;
    subdir = f suffix;
  };

  maybeSuffix = suffix: if suffix == "" then "" else "-" + suffix;

  crucibleF = withSubdirs "crucible"
                (suffix: "crucible" + maybeSuffix suffix);

  # A package in a subdirectory of Crucible
  useCrucible = name: mk {
    inherit name;
    json   = sources.crucible;
    repo   = "crucible";
    subdir = name;
  };

  # We disable tests because they rely on external SMT solvers
  what4 = suffix:
    let name = "what4" + maybeSuffix suffix;
    in useCrucible name;

  macaw = withSubdirs "macaw" (suffix: suffix);

in {

#################################################################
# ** Galois libraries

  # Need newer version, to override cabal2nix's inputs
  abcBridge = wrappers.default (haskellPackagesNew.callPackage ./abcBridge.nix { });

  aig = mk {
    name = "aig";
    json = ./json/aig.json;
    wrapper = wrappers.jailbreakDefault;
  };

  binary-symbols = mk {
    name   = "binary-symbols";
    repo   = "flexdis86";
    subdir = "binary-symbols";
    json   = ./json/flexdis86.json;
  };

  cryptol = mk {
    name   = "cryptol";
    json   = sources.cryptol;
  };

  cryptol-verifier = addABC (mk {
    name = "cryptol-verifier";
    json = sources.cryptol-verifier;
  });

  elf-edit = mk {
    name = "elf-edit";
    json = ./json/elf-edit.json;
  };

  flexdis86 = (mk {
    name = "flexdis86";
    json = ./json/flexdis86.json;
  });

  # The version on Hackage should work, its just not in nixpkgs yet
  parameterized-utils = mk {
    name = "parameterized-utils";
    json = sources.parameterized-utils;
    # TODO: why is this not default?
    wrapper = x: hlib.linkWithGold (hlib.disableLibraryProfiling x);
  };

  saw-script = addABC (mk {
    name    = "saw-script";
    json    = ./json/saw-script.json;
    wrapper = wrappers.exe;
  });

  saw-core = mk {
    name = "saw-core";
    json = sources.saw-core;
  };

  saw-core-aig = mk {
    name = "saw-core-aig";
    json = sources.saw-core-aig;
  };

  # This one takes a long time to build
  saw-core-sbv = mk {
    name = "saw-core-sbv";
    json = sources.saw-core-sbv;
  };

  saw-core-what4 = mk {
    name = "saw-core-what4";
    json = sources.saw-core-what4;
  };

  # crucible-server = crucibleF "server";
  # crucible-syntax = crucibleF "syntax";
  crucible      = crucibleF "";
  crucible-jvm  = crucibleF "jvm";
  crucible-llvm = crucibleF "llvm";
  crucible-saw  = crucibleF "saw";
  crux          = useCrucible "crux";
  crux-llvm     = useCrucible "crux-llvm";

  galois-dwarf = mk {
    name = "dwarf";
    json = ./json/dwarf.json;
  };

  # Hackage version broken
  jvm-parser = mk {
    name = "jvm-parser";
    json = ./json/jvm-parser.json;
  };

  jvm-verifier = addABC (mk {
    name = "jvm-verifier";
    json = ./json/jvm-verifier.json;
  });

  # Tests fail because they lack llvm-as
  llvm-pretty-bc-parser = mk {
    name = "llvm-pretty-bc-parser";
    json = ./json/llvm-pretty-bc-parser.json;
  };

  llvm-verifier = addABC (mk {
    name = "llvm-verifier";
    json = ./json/llvm-verifier.json;
  });

  llvm-pretty = mk {
    name = "llvm-pretty";
    owner = "elliottt";
    json = ./json/llvm-pretty.json;
  };

  macaw-base         = macaw "base";
  macaw-x86          = macaw "x86";
  macaw-symbolic     = macaw "symbolic";
  macaw-x86-symbolic = macaw "x86_symbolic";

  what4     = what4 "";
  what4-sbv = what4 "sbv";
  what4-abc = addABC (what4 "abc");

#################################################################
# ** Haddock

  # https://github.com/haskell/haddock/issues/43

  # haddock-api = mk {
  #   name = "haddock";
  #   owner = "haskell";
  #   json = ./json/tools/haddock.json;
  #   subdir = "haddock-api";
  #   wrapper = wrappers.jailbreakDefault;
  # };

  # haddock = mk {
  #   name = "haddock";
  #   owner = "haskell";
  #   json = ./json/tools/haddock.json;
  #   wrapper = wrappers.jailbreakDefault;
  # };

#################################################################
# ** Hackage dependencies

  # constraints = mk {
  #   name = "constraints";
  #   owner = "ekmett";
  #   json = ./json/constraints.json;
  # };

  itanium-abi = mk {
    name = "itanium-abi";
    owner = "travitch";
    json = ./json/itanium-abi.json;
  };

  # Needed for SBV 8
  crackNum = mk {
    name = "crackNum";
    owner = "LeventErkok";
    json = ./json/crackNum.json;
  };

  # Need SBV 8
  sbv = mk {
    name = "sbv";
    owner = "LeventErkok";
    json = ./json/sbv.json;
  };

  # https://github.com/NixOS/nixpkgs/blob/849b27c62b64384d69c1bec0ef368225192ca096/pkgs/development/haskell-modules/configuration-common.nix#L1080
  hpack     = switchGHC {
    "ghc822"  = hlib.dontCheck haskellPackagesNew.hpack_0_29_6;
    otherwise = haskellPackagesOld.hpack;
  };
  cabal2nix = switchGHC {
    "ghc822"  = hlib.dontCheck haskellPackagesOld.cabal2nix;
    otherwise = haskellPackagesOld.cabal2nix;
  };

  # These are all as of the nixpkgs pinned in json/nixpkgs-master.json.
  # aeson:        ???
  # cereal:       failing test
  # ref-fd:       stm >= 2.1 && <2.5
  # monad-supply: fails on MonadFailDesugaring
  aeson  = switchGHC {
    "ghc843" = wrappers.jailbreak haskellPackagesOld.aeson; # contravariant?
    "ghc844" = wrappers.jailbreak haskellPackagesOld.aeson; # contravariant?
    otherwise = haskellPackagesOld.aeson;
  };
  cereal = switchGHC {
    "ghc843"  = hlib.dontCheck haskellPackagesOld.cereal;
    "ghc844"  = hlib.dontCheck haskellPackagesOld.cereal;
    otherwise = haskellPackagesOld.cereal;
  };
  polyparse  = switchGHC {
    "ghc861" = wrappers.jailbreak haskellPackagesOld.polyparse; # base <4.12
    otherwise = haskellPackagesOld.polyparse;
  };

  ref-fd = switchGHC {
    "ghc863"  = wrappers.jailbreak haskellPackagesOld.ref-fd;
    otherwise = haskellPackagesOld.ref-fd;
  };

  # We intentionally break this:
  monad-supply = switchGHC {
    "ghc863"  = haskellPackagesOld.contravariant;
    otherwise = haskellPackagesOld.monad-supply;
  };

  # These are all as of the nixpkgs pinned in json/nixpkgs-ghc861.json.
  #
  # Glob:          Requires containers <0.6
  # StateVer:      ???
  # cabal-doctest: Requires Cabal >=1.10 && <2.3, base >=4.3 && <4.12
  # contravariant: Requires old base
  # doctest:       Requires old GHC
  # unordered-c:   https://github.com/tibbe/unordered-containers/issues/214
  # hspec-core:    Needs nixpkgs update: https://github.com/hspec/hspec/issues/379
  Glob          = jailbreakOnGHC "ghc861" haskellPackagesOld.Glob;
  StateVar      = jailbreakOnGHC "ghc861" haskellPackagesOld.StateVar;
  cabal-doctest = jailbreakOnGHC "ghc861" haskellPackagesOld.cabal-doctest;
  contravariant = jailbreakOnGHC "ghc861" haskellPackagesOld.contravariant;
  doctest       = jailbreakOnGHC "ghc861" haskellPackagesOld.doctest;
  hspec-core    = jailbreakOnGHC "ghc861" haskellPackagesOld.hspec-core;
  unordered-containers = jailbreakOnGHC "ghc861" haskellPackagesOld.unordered-containers;

#################################################################
# ** haskell-code-explorer

  # Status: not ready for GHC 8.6

  haskell-code-explorer = mk {
    name = "haskell-code-explorer";
    owner = "alexwl";
    json = ./json/tools/haskell-code-explorer.json;
  };

  # cabal-helper    = hlib.doJailbreak (mk {
  #   name = "cabal-helper";
  #   owner = "DanielG";
  #   json = ./json/cabal-helper.json;
  #   wrapper = x: wrappers.jailbreak (wrappers.default x);
  # });

  # haskell-code-explorer
  cabal-helper    =
    (wrappers.jailbreak haskellPackagesOld.cabal-helper).overrideAttrs (oldAttrs: {
    src = "${haskellPackagesNew.haskell-code-explorer.src}/vendor/cabal-helper-0.8.1.2";
  });
  haddock-library = wrappers.jailbreak haskellPackagesOld.haddock-library;
}
