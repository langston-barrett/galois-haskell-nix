{ pkgs ? import <nixpkgs> { } }:

# set_source_files_properties(ASTGraphWriter.cpp PROPERTIES COMPILE_FLAGS "-fsanitize=address -fsanitize=undefined -pedantic")
with pkgs; stdenv.mkDerivation {
  name = "mate";
  shellHook = ''
    export CC=clang
    export CXX=clang++
  '';
  buildInputs = [
    cmake
    clang_6
    llvm_6
    nlohmann_json
    pythonPackages.XlsxWriter
    pythonPackages.pycrypto

    # linters and analyzers
    clang-analyzer
    cppcheck
    include-what-you-use
    llvmPackages_6.clang-unwrapped.python
  ] ++ llvm_6.buildInputs;
}
