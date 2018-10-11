{ mkDerivation, abcBridge, aig, alex, ansi-terminal, ansi-wl-pprint
, array, base, binary, bytestring, Cabal, containers, crucible
, crucible-jvm, crucible-llvm, crucible-saw, cryptol
, cryptol-verifier, deepseq, directory, either, elf-edit
, exceptions, executable-path, fetchgit, fgl, filepath, flexdis86
, free, GraphSCC, happy, haskeline, IfElse, jvm-parser
, jvm-verifier, lens, llvm-pretty, llvm-pretty-bc-parser
, llvm-verifier, macaw-base, macaw-symbolic, macaw-x86
, macaw-x86-symbolic, monad-supply, mtl, old-locale, old-time
, parameterized-utils, parsec, pretty, pretty-show, process
, QuickCheck, reflection, saw-core, saw-core-aig, saw-core-sbv
, saw-core-what4, sbv, split, stdenv, template-haskell, temporary
, terminal-size, text, time, transformers, transformers-compat
, utf8-string, vector, what4, xdg-basedir
##################################################### Added
# nix-shell -p cabal2nix --run "cabal2nix --subpath symbolic https://github.com/GaloisInc/macaw > macaw-symbolic.nix"
, fetchFromGitHub
# , git
, writeShellScriptBin
}:

let
  fromJson = builtins.fromJSON (builtins.readFile ./json/saw-script.json);
  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "GaloisInc";
    repo = "saw-script";
  };
in mkDerivation {

  inherit src;
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;
  doCheck = false;
  # The build parses the output of a git command to get the revision. Just provide it instead.
  buildTools = [
    (writeShellScriptBin "git" ''
      echo "galois-haskell-nix"
    '')
  ];

##################################################### Generated

  pname = "saw-script";
  version = "0.2";
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal directory filepath process ];
  libraryHaskellDepends = [
    aig ansi-wl-pprint array base binary bytestring containers crucible
    crucible-jvm crucible-llvm crucible-saw cryptol cryptol-verifier
    deepseq directory either elf-edit exceptions executable-path fgl
    filepath flexdis86 free GraphSCC haskeline IfElse jvm-parser
    jvm-verifier lens llvm-pretty llvm-pretty-bc-parser llvm-verifier
    macaw-base macaw-symbolic macaw-x86 macaw-x86-symbolic monad-supply
    mtl old-locale old-time parameterized-utils parsec pretty
    pretty-show process reflection saw-core saw-core-aig saw-core-sbv
    saw-core-what4 sbv split template-haskell temporary terminal-size
    text time transformers transformers-compat utf8-string vector what4
    xdg-basedir
  ];
  libraryToolDepends = [ alex happy ];
  executableHaskellDepends = [
    abcBridge ansi-terminal base containers cryptol cryptol-verifier
    directory either filepath haskeline QuickCheck saw-core
    transformers
  ];
  license = stdenv.lib.licenses.bsd3;
}
