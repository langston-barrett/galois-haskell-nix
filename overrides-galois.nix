# Overrides to the default Haskell package set for most Galois packages
{ pkgsOld  ? import ./pinned-pkgs.nix { }
, compiler # ? "ghc843"
}:

haskellPackagesNew: haskellPackagesOld:

#################################################################
# ** Utilities and functions

let
  hlib    = pkgsOld.haskell.lib;

  # Wrappers
  disableOptimization = pkg: hlib.appendConfigureFlag pkg "--disable-optimization"; # In newer nixpkgs
  wrappers = rec {
    nocov  = x: hlib.dontCoverage x;
    noprof = x: hlib.disableExecutableProfiling (hlib.disableLibraryProfiling (nocov x));
    notest = x: hlib.dontCheck (noprof x);
    fast = x: disableOptimization (notest x);
    exe = x: hlib.justStaticExecutables (wrappers.default x);
    jailbreak = x: hlib.doJailbreak (wrappers.default x);
    default = fast;
  };

  # Main builder function. Reads in a JSON describing the git revision and
  # SHA256 to fetch, then calls cabal2nix on the source.
  mk =
    { name
    , json
    , owner ? "GaloisInc"
    , repo ? name
    , subdir ? ""
    , sourceFilesBySuffices ? x: y: x
    , wrapper ? wrappers.default
    }:

    let
      fromJson = builtins.fromJSON (builtins.readFile json);

      src = sourceFilesBySuffices
        ((pkgsOld.fetchFromGitHub {
          inherit owner repo;
          inherit (fromJson) rev sha256;
        }) + "/" + subdir) [".hs" "LICENSE" "cabal" ".c"];

    in builtins.trace ("Building: " + name)
         (wrapper
          (haskellPackagesNew.callCabal2nix name src { }));

  abc       = pkgsOld.callPackage ./abc.nix { };
  mkpkg     = import ./mkpkg.nix;
  dontCheck = pkg: pkg.overrideDerivation (_: { doCheck = false; });

  # For packages that have different behavior for different GHC versions
  switchGHC      = arg: arg."${compiler}" or arg.otherwise;

  # Jailbreak a package for a specific version of GHC
  jailbreakOnGHC = ver: pkg: switchGHC {
    "${ver}"  = hlib.dontCheck (hlib.doJailbreak pkg);
    otherwise = pkg;
  };

  withSubdirs = pname: json: f: suffix: mk {
    inherit json;
    name   = pname + "-" + suffix;
    repo   = pname;
    subdir = f suffix;
  };

  maybeSuffix = suffix: if suffix == "" then "" else "-" + suffix;


  crucibleSrc = ./json/crucible.json;
  crucibleF = withSubdirs "crucible" crucibleSrc
                (suffix: "crucible" + maybeSuffix suffix);

  # A package in a subdirectory of Crucible
  useCrucible = name: mk {
    inherit name;
    json   = crucibleSrc;
    repo   = "crucible";
    subdir = name;
    wrapper = wrappers.noprof;
  };

  # We disable tests because they rely on external SMT solvers
  what4 = suffix:
    let name = "what4" + maybeSuffix suffix;
    in dontCheck (useCrucible name);

  macaw = withSubdirs "macaw" ./json/macaw.json (suffix: suffix);

in {

#################################################################
# ** Galois libraries

  # Need newer version, to override cabal2nix's inputs
  abcBridge = wrappers.default (haskellPackagesNew.callPackage ./abcBridge.nix { });

  aig = mk {
    name = "aig";
    json = ./json/aig.json;
    wrapper = wrappers.jailbreak;
    # wrapper = switchGHC {
    #   "ghc863"  = wrappers.jailbreak;
    #   otherwise = wrappers.default;
    # };
  };

  # The version on Hackage should work, its just not in nixpkgs yet
  parameterized-utils = mk {
    name = "parameterized-utils";
    json = ./json/parameterized-utils.json;
    wrapper = x: hlib.linkWithGold (hlib.disableLibraryProfiling x);
  };

  saw-script = wrappers.exe (switchGHC {
    "ghc843"  = haskellPackagesNew.callPackage ./ghc843/saw-script.nix;
    otherwise = mk {
      name    = "saw-script";
      json    = ./json/saw-script.json;
    };
  });

  saw-core = mk {
    name = "saw-core";
    json = ./json/saw-core.json;
  };

  saw-core-aig = mk {
    name = "saw-core-aig";
    json = ./json/saw-core-aig.json;
  };

  # This one takes a long time to build
  saw-core-sbv = mk {
    name = "saw-core-sbv";
    json = ./json/saw-core-sbv.json;
  };

  saw-core-what4 = mk {
    name = "saw-core-what4";
    json = ./json/saw-core-what4.json;
  };

  # crucible-server = crucibleF "server";
  crucible        = crucibleF "";
  crucible-c      = wrappers.notest (crucibleF "c");
  crucible-jvm    = dontCheck (crucibleF "jvm");
  crucible-saw    = crucibleF "saw";
  # crucible-syntax = crucibleF "syntax";
  crux            = useCrucible "crux";
  crucible-llvm   = switchGHC {
    "ghc843"  = haskellPackagesNew.callPackage ./ghc843/crucible-llvm.nix { };
    otherwise = (crucibleF "llvm");
    # otherwise = (crucibleF "llvm").overrideAttrs (oldAttrs: {
    #   postUnpack = "sourceRoot+=/crucible-llvm; echo source root reset to $sourceRoot";
    # });
  };

  what4     = what4 "";
  what4-sbv = what4 "sbv";
  what4-abc = (what4 "abc").overrideDerivation (oldAttrs: {
      buildPhase = ''
        export NIX_LDFLAGS+=" -L${abc} -L${abc}/lib"
        ${oldAttrs.buildPhase}
      '';
      librarySystemDepends = [ abc ];
  });

  # Cryptol needs base-compat < 0.10, version is 0.10.4
  cryptol = hlib.doJailbreak haskellPackagesOld.cryptol;

  cryptol-verifier = mk {
    name = "cryptol-verifier";
    json = ./json/cryptol-verifier.json;
  };

  elf-edit = mk {
    name = "elf-edit";
    json = ./json/elf-edit.json;
  };

  flexdis86 = (mk {
    name = "flexdis86";
    json = ./json/flexdis86.json;
  });

  binary-symbols = mk {
    name   = "binary-symbols";
    repo   = "flexdis86";
    subdir = "binary-symbols";
    json   = ./json/flexdis86.json;
  };

  galois-dwarf = mk {
    name = "dwarf";
    json = ./json/dwarf.json;
  };

  # Hackage version broken
  jvm-parser = mk {
    name = "jvm-parser";
    json = ./json/jvm-parser.json;
  };

  jvm-verifier = mk {
    name = "jvm-verifier";
    json = ./json/jvm-verifier.json;
    wrapper = hlib.dontCheck;
  };

  # Tests fail because they lack llvm-as
  llvm-pretty-bc-parser = mk {
    name = "llvm-pretty-bc-parser";
    json = ./json/llvm-pretty-bc-parser.json;
  };

  llvm-verifier = mk {
    name = "llvm-verifier";
    json = ./json/llvm-verifier.json;
  };

  llvm-pretty = mk {
    name = "llvm-pretty";
    owner = "elliottt";
    json = ./json/llvm-pretty.json;
  };

  macaw-base         = macaw "base";
  macaw-x86          = macaw "x86";
  macaw-symbolic     = switchGHC {
    "ghc843"  = haskellPackagesNew.callPackage ./ghc843/macaw-symbolic.nix { };
    otherwise = macaw "symbolic";
  };
  macaw-x86-symbolic = switchGHC {
    "ghc843"  = haskellPackagesNew.callPackage ./ghc843/macaw-x86-symbolic.nix { };
    otherwise = macaw "x86_symbolic";
  };

#################################################################
# ** Hackage dependencies

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
# ** Tools

  # Status: not ready for GHC 8.6

  haskell-code-explorer = mk {
    name = "haskell-code-explorer";
    owner = "alexwl";
    json = ./json/haskell-code-explorer.json;
  };

  # cabal-helper    = hlib.doJailbreak (mk {
  #   name = "cabal-helper";
  #   owner = "DanielG";
  #   json = ./json/cabal-helper.json;
  #   wrapper = x: wrappers.jailbreak (wrappers.default x);
  # });

  # haskell-code-explorer
  cabal-helper    = wrappers.jailbreak haskellPackagesOld.cabal-helper;
  haddock-library = wrappers.jailbreak haskellPackagesOld.haddock-library;
}
