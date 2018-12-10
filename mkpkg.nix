{ name
, json
, owner ? "GaloisInc"
, repo ? name
, subdir ? ""
, sourceFilesBySuffices ? x: y: x
, ...
}:

{ haskellPackages, fetchFromGitHub, callCabal2nix }:

# nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/GaloisInc/saw-core > saw-core.json"

let
  fromJson = builtins.fromJSON (builtins.readFile json);

  src = sourceFilesBySuffices
    ((fetchFromGitHub {
      inherit owner repo;
      inherit (fromJson) rev sha256;
    }) + "/" + subdir) [".hs" "LICENSE" "cabal" ".c"];

in haskellPackages.callCabal2nix name src { }
