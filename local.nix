# Compose the default (galois) overrides with ones for local sources
{ pkgsOld ? import ./pinned-pkgs.nix { path = ./json/nixpkgs.json; }
, compiler ? "ghc843"
}:

let
  overrides1 = import ./overrides-galois.nix { inherit pkgsOld compiler; };
  overrides2 = import ./overrides-local.nix  { inherit pkgsOld compiler; };
in import ./default.nix {
  inherit pkgsOld compiler;
  overrides = pkgsOld.lib.composeExtensions overrides1 overrides2;
}
