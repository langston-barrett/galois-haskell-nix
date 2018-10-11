# Compose the default (galois) overrides with ones for local sources
{ pkgsOld ? import ./pinned-pkgs.nix { }
, compiler ? "ghc822"
}:

let
  overrides1 = import ./overrides-galois.nix { };
  overrides2 = import ./overrides-local.nix { };
in import ./default.nix {
  inherit pkgsOld compiler;
  overrides = pkgsOld.lib.composeExtensions overrides1 overrides2;
}
