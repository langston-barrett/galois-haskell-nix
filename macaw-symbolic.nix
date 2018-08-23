{ mkDerivation, ansi-wl-pprint, base, containers, crucible
, crucible-llvm, fetchgit, lens, macaw-base, mtl
, parameterized-utils, stdenv, text, what4
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
  } + "/symbolic";
in mkDerivation {

  inherit src;
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;

##################################################### Generated

  pname = "macaw-symbolic";
  version = "0.0.1";
  libraryHaskellDepends = [
    ansi-wl-pprint base containers crucible crucible-llvm lens
    macaw-base mtl parameterized-utils text what4
  ];
  license = stdenv.lib.licenses.bsd3;
}
