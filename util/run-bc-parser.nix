# { pkgs ? import ../pinned-pkgs.nix { } }:
# { pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { } }:
{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let name = "llvm-pretty-bc-parser";
    this = (import ../local.nix { }).haskellPackages.${name};
    makefile = copyPathToStore ./run-bc-parser.make;
    script   = copyPathToStore ./run-bc-parser.sh;

    llvm   = pkgs.llvm_7;
    stdenv = pkgs.llvmPackages_7.libcxxStdenv;

    libs = import ../../whole-world-llvm/libs.nix { inherit llvm stdenv; };
    fizzbc      = copyPathToStore ../../fizz-hkdf/nix/linked.HkdfTest.bc;
    libcxxbc    = libs.libcxx.bitcode;
    libcxxabibc = libs.libcxxabi.bitcode;

    csrc = writeTextFile {
      name = "test.c";
      text = ''
        int main() {
          int x = 5;
          int y = 2;
          return 0;
        }
      '';
    };
in stdenv.mkDerivation {
   name = "run-${name}";
   buildInputs = [ this llvm ];
   src         = lib.sourceFilesBySuffices ./. [ "LICENSE" ];
   unpackPhase = "";
   buildPhase  = ''
     cp ${script} ./run-bc-parser.sh
     cp ${makefile} ./Makefile

     # Copy bitcode
     for f in ${libcxxabibc}/*.bc ${libcxxbc}/*.bc; do
       (cp "$f" . || true)
     done
     cp ${fizzbc} ./test.bc

     # Compile C
     cp ${csrc} ./prog.c
     for f in *.c; do
       clang -g -O0 -emit-llvm -c "$f"
     done

     # Create make options
     declare -a opts
     for f in *.bc; do
       opts+=( $f.log )
     done

     # Run the bitcode parser
     make -j8 ''${opts[@]}
   '';
   installPhase = ''
     mkdir -p $out
     for f in *.bc *.log *.ll *.xml; do
       cp "$f" "$out"
     done
   '';
}
