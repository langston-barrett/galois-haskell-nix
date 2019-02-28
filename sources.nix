# * Sources
#
# Choose which sources to use. The options are: "master" or "saw"
{ pkgs       ? import ./pinned-pkgs.nix { }
, sourceType ? "saw"
}:

let
  case = arg: arg."${sourceType}" or arg.master;
in {
  # auto-yasnippet: SPC i S c
  # ~pkg = case {
  #   saw    = ./json/saw/~pkg.json;
  #   master = ./json/~pkg.json;
  # };
  crucible = case {
    saw    = ./json/saw/crucible.json;
    master = ./json/crucible.json;
  };
  cryptol = case {
    saw    = ./json/saw/cryptol.json;
    master = ./json/cryptol.json;
  };
  cryptol-verifier = case {
    saw    = ./json/saw/cryptol-verifier.json;
    master = ./json/cryptol-verifier.json;
  };
  macaw = case {
    # saw    = ./json/saw/macaw.json;
    saw    = ./json/saw/macaw.json;
    master = ./json/saw/macaw.json;
  };
  llvm-pretty = case {
    saw    = ./json/saw/llvm-pretty.json;
    master = ./json/llvm-pretty.json;
  };
  parameterized-utils = case {
    saw    = ./json/saw/parameterized-utils.json;
    master = ./json/parameterized-utils.json;
  };
  saw-core = case {
    saw    = ./json/saw/saw-core.json;
    master = ./json/saw-core.json;
  };
  saw-core-aig = case {
    saw    = ./json/saw/saw-core-aig.json;
    master = ./json/saw-core-aig.json;
  };
  saw-core-sbv = case {
    saw    = ./json/saw/saw-core-sbv.json;
    master = ./json/saw-core-sbv.json;
  };
  saw-core-what4 = case {
    saw    = ./json/saw/saw-core-what4.json;
    master = ./json/saw-core-what4.json;
  };
}
