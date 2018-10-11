{ mkDerivation, ansi-wl-pprint, base, containers, crucible
, crucible-llvm, fetchgit, lens, macaw-base, mtl
, parameterized-utils, stdenv, text, what4
##################################################### Added
# nix-shell -p cabal2nix --run "cabal2nix --subpath symbolic https://github.com/GaloisInc/macaw > macaw-symbolic.nix"
, fetchFromGitHub
}:

let
  fromJson = builtins.fromJSON (builtins.readFile ../json/macaw.json);
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
