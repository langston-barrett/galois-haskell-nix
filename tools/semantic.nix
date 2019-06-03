# * semantic
#
# https://github.com/github/semantic
#
# run: for file in pkgs/*.nix; do sed -i 's/fetchSubmodules = true;/fetchSubmodules = false;/' $file; done
#
{ pkgs ? import ../pinned-pkgs.nix { path = pkgsPath; }
, pkgsPath ? ../json/nixpkgs/19.03.json
}:

import ../default.nix {
  pkgsNew   = pkgsPath;
  compiler  = "ghc864";
  overrides = haskellPackagesNew: haskellPackagesOld:
    let hlib = pkgs.haskell.lib;
        mk = import ../mk.nix {
          inherit (pkgs) fetchFromGitHub;
          inherit hlib;
          haskellPackages = haskellPackagesNew;
        };
        wrappers = import ../wrappers.nix { inherit hlib; };
    in {
      # auto-yasnippet: SPC i S c
      # ~pkg = haskellPackagesOld.callPackage ./pkgs/~pkg.nix { };
      semantic = haskellPackagesOld.callPackage ./pkgs/semantic.nix { };
      freer-cofreer = hlib.dontCheck (haskellPackagesOld.callPackage ./pkgs/freer-cofreer.nix { });
      fused-effects-exceptions = haskellPackagesOld.callPackage ./pkgs/fused-effects-exceptions.nix { };
      proto3-suite = hlib.dontCheck (haskellPackagesOld.callPackage ./pkgs/proto3-suite.nix { });
      proto3-wire = haskellPackagesOld.callPackage ./pkgs/proto3-wire.nix { };
      fused-effects = hlib.dontCheck (haskellPackagesOld.callPackage ./pkgs/fused-effects.nix { });

      haskell-tree-sitter = (haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter.nix { }).overrideAttrs (oldAttrs: {
        # buildPhase = ''
        #   export NIX_LDFLAGS+=" -L${abc} -L${abc}/lib"
        #   ${oldAttrs.buildPhase}
        # '';
        librarySystemDepends = [ pkgs.tree-sitter ]; # TODO
      });
      # tree-sitter-~lang = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-~lang.nix { };
      tree-sitter-go = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-go.nix { };
      tree-sitter-haskell = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-haskell.nix { };
      tree-sitter-java = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-java.nix { };
      tree-sitter-json = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-json.nix { };
      tree-sitter-php = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-php.nix { };
      tree-sitter-python = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-python.nix { };
      tree-sitter-ruby = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-ruby.nix { };
      tree-sitter-typescript = haskellPackagesOld.callPackage ./pkgs/haskell-tree-sitter-typescript.nix { };

      # ~pkg = hlib.dontCheck haskellPackagesOld.~pkg;
      semilattices = hlib.dontCheck  haskellPackagesOld.semilattices;
      heap = hlib.dontCheck haskellPackagesOld.heap;
      kdt = hlib.dontCheck haskellPackagesOld.kdt;
      range-set-list = hlib.dontCheck haskellPackagesOld.range-set-list;
    };
}
