{ pkgs_old ? import ./pinned-pkgs.nix { }
, compiler ? "ghc843"
}:

# Here's how to manually update a dependency
let
  abc = with pkgs_old; callPackage ./abc.nix { };
  galoisOverrides = haskellPackagesNew: haskellPackagesOld:
    let
      lib   = pkgs_old.haskell.lib;
      mkpkg = import ./mkpkg.nix;
      withSubdirs = pname: json: f: suffix:
        haskellPackagesNew.callPackage (mkpkg {
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
    in {

    # Need newer version, to override cabal2nix's inputs
    abcBridge = haskellPackagesNew.callPackage ./abcBridge.nix { };

    # Broken: depends on everything else
    saw = haskellPackagesOld.callPackage ./saw-script.nix { };
    # saw = haskellPackagesOld.callPackage ./saw-script.nix { git = pkgs_old.git; };

    # The version on Hackage should work, its just not in nixpkgs yet
    parameterized-utils = haskellPackagesNew.callPackage (mkpkg {
      name = "parameterized-utils";
      json = ./parameterized-utils.json;
      }) { };

    saw-core = haskellPackagesNew.callPackage (mkpkg {
      name = "saw-core";
      json = ./saw-core.json;
      }) { };

    saw-core-aig = haskellPackagesNew.callPackage (mkpkg {
      name = "saw-core-aig";
      json = ./saw-core-aig.json;
      }) { };

    # This one takes a long time to build
    saw-core-sbv = haskellPackagesNew.callPackage (mkpkg {
      name = "saw-core-sbv";
      json = ./saw-core-sbv.json;
      }) { };

    saw-core-what4 = haskellPackagesNew.callPackage (mkpkg {
      name = "saw-core-what4";
      json = ./saw-core-what4.json;
    }) { };

    hpb = haskellPackagesNew.callPackage (mkpkg { # Haskell Protocol Buffers
      name = "hpb";
      json = ./hpb.json;
    }) { };

    crucible        = crucibleF "";
    crucible-c      = crucibleF "c";
    crucible-jvm    = crucibleF "jvm";
    crucible-server = crucibleF "server";
    crucible-saw    = crucibleF "saw";
    # This package can't be built with profiling on with GHC 8.4.3.
    # This change has to be propagated to all the packages that depend on it.
    crucible-llvm   = haskellPackagesOld.callPackage ./crucible-llvm.nix { };

    what4 = haskellPackagesNew.callPackage (mkpkg {
      name   = "what4";
      repo   = "crucible";
      json   = ./crucible.json;
      subdir = "what4";
    }) { };

    what4-abc = haskellPackagesNew.callPackage ./what4-abc.nix { inherit abc; };

    # Cryptol needs base-compat < 0.10, version is 0.10.4
    # cryptol = lib.doJailbreak haskellPackagesOld.cryptol;
    # crucible-server needs cryptol > hackage
    cryptol = haskellPackagesNew.callPackage (mkpkg {
      name = "cryptol";
      json = ./cryptol.json;
    }) { };

    # Broken
    cryptol-verifier = haskellPackagesNew.callPackage (mkpkg {
      name = "cryptol-verifier";
      json = ./cryptol-verifier.json;
    }) { };

    elf-edit = haskellPackagesNew.callPackage (mkpkg {
      name = "elf-edit";
      json = ./elf-edit.json;
    }) { };

    flexdis86 = haskellPackagesNew.callPackage (mkpkg {
      name = "flexdis86";
      json = ./flexdis86.json;
    }) { };

    binary-symbols = haskellPackagesNew.callPackage (mkpkg {
      name   = "binary-symbols";
      repo   = "flexdis86";
      subdir = "binary-symbols";
      json   = ./flexdis86.json;
    }) { };

    galois-dwarf = haskellPackagesNew.callPackage (mkpkg {
      name = "dwarf";
      json = ./dwarf.json;
    }) { };

    # Hackage version broken
    jvm-parser = haskellPackagesNew.callPackage (mkpkg {
      name = "jvm-parser";
      json = ./jvm-parser.json;
    }) { };

    jvm-verifier = haskellPackagesNew.callPackage ./jvm-verifier.nix { };

    llvm-pretty-bc-parser = haskellPackagesNew.callPackage (mkpkg {
      name = "llvm-pretty-bc-parser";
      json = ./llvm-pretty-bc-parser.json;
    }) { };

    llvm-verifier = haskellPackagesNew.callPackage (mkpkg {
      name = "llvm-verifier";
      json = ./llvm-verifier.json;
    }) { };

    llvm-pretty = haskellPackagesNew.callPackage (mkpkg {
      name = "llvm-pretty";
      owner = "elliottt";
      json = ./llvm-pretty.json;
    }) { };

    macaw-base         = macaw "base";
    # macaw-symbolic     = macaw "symbolic"; # Broken: crucible-llvm
    macaw-symbolic = haskellPackagesNew.callPackage ./macaw-symbolic.nix { };
    macaw-x86          = macaw "x86";
    # macaw-x86-symbolic = macaw "x86_symbolic"; # Broken: crucible-llvm
    macaw-x86-symbolic = haskellPackagesNew.callPackage ./macaw-x86-symbolic.nix { };
  };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

in import (pkgs_old.fetchFromGitHub {
  owner = "NixOS";
  repo  = "nixpkgs";
  inherit (nixpkgs) rev sha256;
}) {
  config = {
    allowUnfree = true; # https://github.com/GaloisInc/flexdis86/pull/1
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskell.packages."${compiler}".override {
        overrides = galoisOverrides;
      };
    };
  };
}
