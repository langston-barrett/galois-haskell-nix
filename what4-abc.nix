{ mkDerivation, abcBridge, aig, ansi-wl-pprint, base, containers
, directory, fetchgit, io-streams, lens, mtl, parameterized-utils
, process, stdenv, text, transformers, unordered-containers
, utf8-string, what4
##################################################### Added
# nix-shell -p cabal2nix --run "cabal2nix --subpath what4-abc https://github.com/GaloisInc/crucible > what4-abc.nix"
, abc
, fetchFromGitHub
}:
let
  fromJson = builtins.fromJSON (builtins.readFile ./crucible.json);
  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "GaloisInc";
    repo = "crucible";
  };
in mkDerivation {

  librarySystemDepends = [ abc ];
  inherit src;

##################################################### Generated

  pname = "what4-abc";
  version = "0.1";
  postUnpack = "sourceRoot+=/what4-abc; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    abcBridge aig ansi-wl-pprint base containers directory io-streams
    lens mtl parameterized-utils process text transformers
    unordered-containers utf8-string what4
  ];
  description = "What4 bindings to ABC";
  license = stdenv.lib.licenses.bsd3;
}
