# Overrides to the default Haskell package set for most Galois packages
{ pkgsOld ? import ./pinned-pkgs.nix { }
, compiler ? "ghc843"
}:

haskellPackagesNew: haskellPackagesOld:
let
  hmk   = haskellPackagesNew.callPackage;
  hlib  = pkgsOld.haskell.lib;
  mkpkg = import ./mkpkg.nix;
  withSubdirs = pname: json: f: suffix:
    hmk (mkpkg {
      inherit json;
      name   = pname + suffix;
      repo   = pname;
      subdir = f suffix;
    }) { };
  crucibleF =
    withSubdirs "crucible" ./crucible.json
      (suffix: "crucible" + (if suffix == "" then "" else "-" + suffix));
  macaw =
    withSubdirs "macaw" ./macaw.json (suffix: suffix);

  # When using GHC 8.4.3, we have to disable profiling for some packages
  # See the README
  disableProfiling843 = pkg:
    pkg.overrideDerivation (oldAttrs:
      (if compiler == "ghc843"
      then {
        enableLibraryProfiling = false;
        enableExecutableProfiling = false;
      }
      else { }));
in {

  # Need newer version, to override cabal2nix's inputs
  abcBridge = haskellPackagesNew.callPackage ./abcBridge.nix { };

  # The version on Hackage should work, its just not in nixpkgs yet
  parameterized-utils = hmk (mkpkg {
    name = "parameterized-utils";
    json = ./parameterized-utils.json;
    }) { };

  saw-script = (hmk (mkpkg {
    name = "saw-script";
    json = ./json/saw-script.json;
  }) { }).overrideDerivation (oldAttrs:
    # When using GHC 8.4.3, we have to disable profiling, see README
    (if compiler == "ghc843"
    then {
      enableLibraryProfiling = false;
      enableExecutableProfiling = false;
    }
    else {
    })
    // {
      # The build parses the output of a git command to get the revision. Just provide it instead.
      buildTools = [
        (pkgsOld.writeShellScriptBin "git" ''
          echo ${oldAttrs.src.rev}
        '')
      ];
    });

  saw-core = hmk (mkpkg {
    name = "saw-core";
    json = ./saw-core.json;
  }) { };

  saw-core-aig = hmk (mkpkg {
    name = "saw-core-aig";
    json = ./saw-core-aig.json;
  }) { };

  # This one takes a long time to build
  saw-core-sbv = hmk (mkpkg {
    name = "saw-core-sbv";
    json = ./saw-core-sbv.json;
  }) { };

  saw-core-what4 = hmk (mkpkg {
    name = "saw-core-what4";
    json = ./saw-core-what4.json;
  }) { };

  crucible        = crucibleF "";
  crucible-c      = crucibleF "c";
  crucible-jvm    = crucibleF "jvm";
  # crucible-server = crucibleF "server";
  crucible-saw    = crucibleF "saw";
  crucible-llvm   = disableProfiling843 (crucibleF "llvm");

  what4 = hmk (mkpkg {
    name   = "what4";
    repo   = "crucible";
    json   = ./crucible.json;
    subdir = "what4";
  }) { };

  # Cryptol needs base-compat < 0.10, version is 0.10.4
  cryptol = pkgsOld.haskell.lib.doJailbreak haskellPackagesOld.cryptol;

  cryptol-verifier = hmk (mkpkg {
    name = "cryptol-verifier";
    json = ./cryptol-verifier.json;
  }) { };

  elf-edit = hmk (mkpkg {
    name = "elf-edit";
    json = ./elf-edit.json;
  }) { };

  flexdis86 = hmk (mkpkg {
    name = "flexdis86";
    json = ./flexdis86.json;
  }) { };

  binary-symbols = hmk (mkpkg {
    name   = "binary-symbols";
    repo   = "flexdis86";
    subdir = "binary-symbols";
    json   = ./flexdis86.json;
  }) { };

  galois-dwarf = hmk (mkpkg {
    name = "dwarf";
    json = ./dwarf.json;
  }) { };

  # Hackage version broken
  jvm-parser = hmk (mkpkg {
    name = "jvm-parser";
    json = ./jvm-parser.json;
  }) { };

  jvm-verifier = hmk (mkpkg {
    name = "jvm-verifier";
    json = ./jvm-verifier.json;
  }) { };

  llvm-pretty-bc-parser = hmk (mkpkg {
    name = "llvm-pretty-bc-parser";
    json = ./llvm-pretty-bc-parser.json;
  }) { };

  llvm-verifier = hmk (mkpkg {
    name = "llvm-verifier";
    json = ./llvm-verifier.json;
  }) { };

  llvm-pretty = hmk (mkpkg {
    name = "llvm-pretty";
    owner = "elliottt";
    json = ./llvm-pretty.json;
  }) { };

  macaw-base         = macaw "base";
  macaw-symbolic     = disableProfiling843 (macaw "symbolic");
  macaw-x86          = macaw "x86";
  macaw-x86-symbolic = disableProfiling843 (macaw "x86-symbolic");

  # https://github.com/NixOS/nixpkgs/blob/849b27c62b64384d69c1bec0ef368225192ca096/pkgs/development/haskell-modules/configuration-common.nix#L1080
  hpack     = if compiler == "ghc822"
              then pkgsOld.haskell.lib.dontCheck haskellPackagesNew.hpack_0_29_6
              else haskellPackagesOld.hpack;
  cabal2nix = if compiler == "ghc822"
              then pkgsOld.haskell.lib.dontCheck haskellPackagesOld.cabal2nix
              else haskellPackagesOld.cabal2nix;
}
