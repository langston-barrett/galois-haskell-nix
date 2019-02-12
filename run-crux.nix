{ pkgs ? import ./pinned-pkgs.nix { } }:

with pkgs;
let crux-llvm = (import ./local.nix { }).haskellPackages.crux-llvm;
    csrc = writeTextFile {
      name = "test.c";
      text = ''
        #include <string.h>
        int main() {
          if (strlen("const") > 3) {
            return strlen("true");
          }
          return 0;
        }
      '';
    };
    fizzbc = copyPathToStore ../fizz-hkdf/nix/linked.HkdfTest.bc;
in stdenv.mkDerivation {
   name = "run-crux";
   buildInputs = [ clang_6 llvm_6 z3 crux-llvm ];
   src         = lib.sourceFilesBySuffices ./. [ "LICENSE" ];
   unpackPhase = "";
   buildPhase  = ''
     cp ${fizzbc} ./test.bc
     ${crux-llvm}/bin/crux-llvm test.bc |& tee log
     # llvm-dis test.bc
   '';
   installPhase = ''
     mkdir -p $out
     cp log     $out
     # cp test.ll $out
   '';
}
