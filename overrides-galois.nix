# Overrides to the default Haskell package set for most Galois packages
{ pkgs_old ? import ./pinned-pkgs.nix { } }:

haskellPackagesNew: haskellPackagesOld:
let
  hmk   = haskellPackagesNew.callPackage;
  hlib  = pkgs_old.haskell.lib;
  mkpkg = import ./mkpkg.nix;
  withSubdirs = pname: json: f: suffix:
    hmk (mkpkg {
      inherit json;
      name   = pname + suffix;
      repo   = pname;
      subdir = f suffix;
    }) { };
  crucibleF =
    withSubdirs "crucible" ./json/crucible.json
      (suffix: "crucible" + (if suffix == "" then "" else "-" + suffix));
  macaw =
    withSubdirs "macaw" ./json/macaw.json (suffix: suffix);
in {

  # Need newer version, to override cabal2nix's inputs
  abcBridge = haskellPackagesNew.callPackage ./abcBridge.nix { };

  # The version on Hackage should work, its just not in nixpkgs yet
  parameterized-utils = hmk (mkpkg {
    name = "parameterized-utils";
    json = ./json/parameterized-utils.json;
    }) { };

  saw-script = hmk ./saw-script.nix { };

  saw-core = hmk (mkpkg {
    name = "saw-core";
    json = ./json/saw-core.json;
    }) { };

  saw-core-aig = hmk (mkpkg {
    name = "saw-core-aig";
    json = ./json/saw-core-aig.json;
    }) { };

  # This one takes a long time to build
  saw-core-sbv = hmk (mkpkg {
    name = "saw-core-sbv";
    json = ./json/saw-core-sbv.json;
    }) { };

  saw-core-what4 = hmk (mkpkg {
    name = "saw-core-what4";
    json = ./json/saw-core-what4.json;
    }) { };

  crucible        = crucibleF "";
  crucible-c      = crucibleF "c";
  crucible-jvm    = crucibleF "jvm";
  # crucible-server = crucibleF "server";
  crucible-saw    = crucibleF "saw";
  # crucible-llvm   = haskellPackagesOld.callPackage ./crucible-llvm.nix { };
  crucible-llvm   =
    (haskellPackagesOld.callPackage ./crucible-llvm.nix { }).overrideDerivation
      (oldAttrs: {
        src = pkgs_old.lib.sourceFilesBySuffices
                ../crucible/crucible-llvm [".hs" "LICENSE" "cabal" ".c"];
        postUnpack = null;
        doCheck    = false;
      });

  what4-abc = hmk (mkpkg {
    name   = "what4-abc";
    repo   = "crucible";
    json   = ./json/crucible.json;
    subdir = "what4-abc";
  }) { };

  what4 = hmk (mkpkg {
    name   = "what4";
    repo   = "crucible";
    json   = ./json/crucible.json;
    subdir = "what4";
  }) { };

  # Cryptol needs base-compat < 0.10, version is 0.10.4
  cryptol = pkgs_old.haskell.lib.doJailbreak haskellPackagesOld.cryptol;

  cryptol-verifier = hmk (mkpkg {
    name = "cryptol-verifier";
    json = ./json/cryptol-verifier.json;
  }) { };

  elf-edit = hmk (mkpkg {
    name = "elf-edit";
    json = ./json/elf-edit.json;
  }) { };

  flexdis86 = hmk (mkpkg {
    name = "flexdis86";
    json = ./json/flexdis86.json;
  }) { };

  binary-symbols = hmk (mkpkg {
    name   = "binary-symbols";
    repo   = "flexdis86";
    subdir = "binary-symbols";
    json   = ./json/flexdis86.json;
  }) { };

  galois-dwarf = hmk (mkpkg {
    name = "dwarf";
    json = ./json/dwarf.json;
  }) { };

  # Hackage version broken
  jvm-parser = hmk (mkpkg {
    name = "jvm-parser";
    json = ./json/jvm-parser.json;
  }) { };

  # Broken
  jvm-verifier = hmk (mkpkg {
    name = "jvm-verifier";
    json = ./json/jvm-verifier.json;
  }) { };

  llvm-pretty-bc-parser = hmk (mkpkg {
    name = "llvm-pretty-bc-parser";
    json = ./json/llvm-pretty-bc-parser.json;
  }) { };

  llvm-verifier = hmk (mkpkg {
    name = "llvm-verifier";
    json = ./json/llvm-verifier.json;
  }) { };

  llvm-pretty = hmk (mkpkg {
    name = "llvm-pretty";
    owner = "elliottt";
    json = ./json/llvm-pretty.json;
  }) { };

  macaw-base         = macaw "base";
  # macaw-symbolic     = macaw "symbolic"; # Broken: crucible-llvm
  macaw-symbolic = haskellPackagesNew.callPackage ./macaw-symbolic.nix { };
  macaw-x86          = macaw "x86";
  # macaw-x86-symbolic = macaw "x86_symbolic"; # Broken: crucible-llvm
  macaw-x86-symbolic = haskellPackagesNew.callPackage ./macaw-x86-symbolic.nix { };

  # https://github.com/NixOS/cabal2commit/f895510181017fd3dc478436229e92e1e8ea8009
  # https://github.com/NixOS/nixpkgs/blob/849b27c62b64384d69c1bec0ef368225192ca096/pkgs/development/haskell-modules/configuration-common.nix#L1080
  # hpack = haskellPackagesNew.hpack_0_29_6;
  # cabal2nix = pkgs_old.haskell.lib.dontCheck haskellPackagesOld.cabal2nix;
}
