# Main builder function. Reads in a JSON describing the git revision and
# SHA256 to fetch, then calls cabal2nix on the source.
{ fetchFromGitHub
, haskellPackages
}:

{ name
, json
, owner ? "GaloisInc"
, repo ? name
, subdir ? ""
, sourceFilesBySuffices ? x: y: x
, wrapper ? x: x
}:

let
  fromJson = builtins.fromJSON (builtins.readFile json);

  src = sourceFilesBySuffices
    ((fetchFromGitHub {
      inherit owner repo;
      inherit (fromJson) rev sha256;
    }) + "/" + subdir) [".hs" "LICENSE" "cabal" ".c"];

in builtins.trace ("mk: " + name)
      (wrapper
      (haskellPackages.callCabal2nix name src { }))
