{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { } }:

# set_source_files_properties(ASTGraphWriter.cpp PROPERTIES COMPILE_FLAGS "-fsanitize=address -fsanitize=undefined -pedantic")
with pkgs; stdenv.mkDerivation {
  name = "mate";
  shellHook = ''
    export CC=clang
    export CXX=clang++

    guessing_game() {
      tp *.csv *.db
      pushd ../../../llvm/build && make -j2 ; popd && \
        (opt -load ../../../llvm/build/MATE/libMATE.so -ast-graph-writer guessing-game.ll |& tee log) && \
        pushd ../../../db && \
        python mate.py ../tests/simple/guessing-game/mate.db \
          ../tests/simple/guessing-game/nodes.csv \
          ../tests/simple/guessing-game/edges.csv;
        popd
    }
  '';
  propagatedBuildInputs = [
    git
    zsh

    cmake
    clang_6
    llvm_6
    curl
    nlohmann_json
    python
    pythonPackages.XlsxWriter
    pythonPackages.pycrypto

    # Query
    # nix-env -iA nixos.python3 nixos.python37Packages.virtualenvwrapper
    python3Packages.mypy
    python3Packages.pytest
    python3Packages.hypothesis
    python3Packages.jsonschema
    # python36Packages.virtualenv

    # Shake
    haskellPackages.cabal-install
    # (haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [ shake ]))
    (haskell.packages.ghc822.ghcWithPackages (h: with h; [
      shake
      # sqlite-simple
      # optparse-applicative
    ]))

    # linters, analyzers, dev tools
    # Python
    # pythonPackages.autoflake
    python3Packages.flake8
    python3Packages.importmagic
    python3Packages.yapf

    # C++
    clang-analyzer
    cppcheck
    include-what-you-use
    llvmPackages_6.clang-unwrapped.python
  ] ++ llvm_6.buildInputs;
}
