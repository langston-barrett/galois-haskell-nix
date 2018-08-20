{ mkDerivation, base, bytestring, containers, crucible
, crucible-llvm, elf-edit, fetchgit, flexdis86, lens, macaw-base
, macaw-symbolic, macaw-x86, mtl, parameterized-utils, stdenv, text
, vector, what4
##################################################### Added
# Generated with cabal2nix and set
# enableLibraryProfiling = false;
# enableExecutableProfiling = false;
# manually
, fetchFromGitHub
}:
let
  fromJson = builtins.fromJSON (builtins.readFile ./macaw.json);

  # For some reason, nix-prefetch-git --deepClone doesn't compute the
  # correct SHA256, so we just handle this one manually.
  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "GaloisInc";
    repo = "macaw";
  } + "/x86_symbolic";
in mkDerivation {

  inherit src;
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;
  doCheck = false;

##################################################### Generated

  pname = "macaw-x86-symbolic";
  version = "0.0.1";
  libraryHaskellDepends = [
    base crucible crucible-llvm flexdis86 lens macaw-base
    macaw-symbolic macaw-x86 mtl parameterized-utils what4
  ];
  testHaskellDepends = [
    base bytestring containers crucible crucible-llvm elf-edit
    macaw-base macaw-symbolic macaw-x86 parameterized-utils text vector
    what4
  ];
  license = stdenv.lib.licenses.bsd3;
}
