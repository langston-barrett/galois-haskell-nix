{ name
, json
, owner ? "GaloisInc"
, repo ? name
, subdir ? ""
}:

{ haskellPackages, fetchFromGitHub, callCabal2nix }:

# nix-shell -p nix-prefetch-git --run "nix-prefetch-git https://github.com/GaloisInc/saw-core > saw-core.json"

let
  fromJson = builtins.fromJSON (builtins.readFile json);

  src = (fetchFromGitHub {
    inherit owner repo;
    inherit (fromJson) rev sha256;
  }) + "/" + subdir;

in haskellPackages.callCabal2nix name src { }
