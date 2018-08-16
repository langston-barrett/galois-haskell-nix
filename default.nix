{ pkgs_old ? import ./pinned-pkgs.nix { }
, compiler ? "ghc843"
}:

let
  galoisOverrides = haskellPackagesNew: haskellPackagesOld:
    let
      hmk = haskellPackagesNew.callPackage;
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
    in rec {

    abcBridge = haskellPackagesOld.abcBridge.overrideScope
      (self: super: { Cabal = haskellPackagesNew.Cabal_2_2_0_1; });

    saw = (hmk (mkpkg {
      repo = "saw-script";
      name = "saw";
      json = ./saw-script.json;
      }) { });

    # The version on Hackage should work, its just not in nixpkgs yet
    parameterized-utils = hmk (mkpkg {
      name = "parameterized-utils";
      json = ./parameterized-utils.json;
      }) { };

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

    crucible      = crucibleF "";
    crucible-jvm  = crucibleF "jvm"; # Broken
    crucible-llvm = crucibleF "llvm"; # Broken
    crucible-saw  = crucibleF "saw";

    what4 = hmk (mkpkg {
      name   = "what4";
      repo   = "crucible";
      json   = ./crucible.json;
      subdir = "what4";
    }) { };

    # Broken: Cryptol needs base-compat < 0.10
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

    # Broken
    jvm-verifier = hmk (mkpkg {
      name = "jvm-verifier";
      json = ./jvm-verifier.json;
    }) { };

    # Broken, cryptol-verifier
    llvm-verifier = hmk (mkpkg {
      name = "llvm-verifier";
      json = ./llvm-verifier.json;
    }) { };

    # Broken: No instance for (Semigroup Module)
    llvm-pretty = hmk (mkpkg {
      name = "llvm-pretty";
      json = ./llvm-pretty.json;
    }) { };

    macaw-base         = macaw "base";
    macaw-symbolic     = macaw "symbolic"; # Broken: llvm-pretty
    macaw-x86          = macaw "x86";
    macaw-x86-symbolic = macaw "x86_symbolic"; # Broken: llvm-pretty

    # https://github.com/NixOS/cabal2commit/f895510181017fd3dc478436229e92e1e8ea8009
    # https://github.com/NixOS/nixpkgs/blob/849b27c62b64384d69c1bec0ef368225192ca096/pkgs/development/haskell-modules/configuration-common.nix#L1080
    # hpack = haskellPackagesNew.hpack_0_29_6;
    # cabal2nix = pkgs_old.haskell.lib.dontCheck haskellPackagesOld.cabal2nix;
  };


  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskell.packages."${compiler}".override {
        overrides = galoisOverrides;
      };
    };
  };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

in import (pkgs_old.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) { inherit config; }
