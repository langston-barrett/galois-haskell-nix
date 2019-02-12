# * Sources
#
# Choose which sources to use. The options are: "master" or "saw"
{ pkgs      ? import ./pinned-pkgs.nix { }
, buildType ? "saw"
}:

let
  case = arg: arg."${buildType}" or arg.master;
in {
  crucible = case {
    saw    = ./json/saw/crucible.json;
    master = ./json/crucible.json;
  };
  macaw = case {
    saw    = ./json/saw/macaw.json;
    master = ./json/macaw.json;
  };
  llvm-pretty = case {
    saw    = ./json/saw/llvm-pretty.json;
    master = ./json/llvm-pretty.json;
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
