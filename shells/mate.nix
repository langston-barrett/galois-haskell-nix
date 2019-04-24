{ pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { } }:

with pkgs; stdenv.mkDerivation {
  name = "mate";
  shellHook = ''
    export CC=clang
    export CXX=clang++

    # This can be run in the guessing game directory to make it go. 
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

    export PYTHONPATH=$PYTHONPATH:$HOME/code/MATE/db/query
  '';
  propagatedBuildInputs = [
    git

    cmake
    clang_7
    llvm_7
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
    python3Packages.typing-extensions
    python3Packages.sphinx
    # python36Packages.virtualenv

    # Shake
    haskellPackages.cabal-install
    (haskell.packages.ghc822.ghcWithPackages (h: with h; [
      shake
    ]))

    # linters, analyzers, dev tools

    # Python
    # pythonPackages.autoflake
    python3Packages.flake8
    python3Packages.pydocstyle
    python3Packages.importmagic
    python3Packages.pylint
    python3Packages.pycodestyle
    python3Packages.pyflakes
    python3Packages.yapf

    # C++
    boost
    clang-analyzer
    cppcheck
    include-what-you-use
    llvmPackages_7.clang-unwrapped.python

  ] ++ llvm_7.buildInputs;
}
