# Generated with cabal2nix and set 
# enableLibraryProfiling = false;
# enableExecutableProfiling = false;
# manually
{ mkDerivation, ansi-wl-pprint, attoparsec, base, bytestring
, containers, crucible, deepseq, directory, fetchgit, ghc-prim
, hashable, hashtables, lens, llvm-pretty, mtl, parameterized-utils
, stdenv, template-haskell, text, transformers
, unordered-containers, utf8-string, vector, what4
, fetchFromGitHub
}:
let
  fromJson = builtins.fromJSON (builtins.readFile ./crucible-llvm.json);

  # For some reason, nix-prefetch-git --deepClone doesn't compute the
  # correct SHA256, so we just handle this one manually.
  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "GaloisInc";
    repo = "crucible";
  };
in mkDerivation {
  pname = "crucible-llvm";
  version = "0.1";
  src = fetchgit {
    url = "https://github.com/GaloisInc/crucible";
    sha256 = "09zayqyiwidm3c4jxdy1wjhnf90jm7w7bpyv6kbw5v2bsrf9lmmb";
    rev = "fcf1f9ee44ec97758fbb0457129021759975f94a";
  };
  postUnpack = "sourceRoot+=/crucible-llvm; echo source root reset to $sourceRoot";
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;
  configureFlags = [ "--disable-profiling" ];
  libraryHaskellDepends = [
    ansi-wl-pprint attoparsec base bytestring containers crucible
    deepseq directory ghc-prim hashable hashtables lens llvm-pretty mtl
    parameterized-utils template-haskell text transformers
    unordered-containers utf8-string vector what4
  ];
  description = "Support for translating and executing LLVM code in Crucible";
  license = stdenv.lib.licenses.bsd3;
}
