{ callPackage, fetchFromGitHub }:

let
  fromJson = builtins.fromJSON (builtins.readFile ./abc.json);

  src = fetchFromGitHub {
    inherit (fromJson) rev sha256;
    owner = "kquick";
    repo = "crucible_nix";
  };
in callPackage (src + "/abc.nix") { }
