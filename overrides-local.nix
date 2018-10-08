# Overrides for using local versions of sources.
# Good for hacking on multiple parts of the package set.
{ pkgs_old ? import ./pinned-pkgs.nix { } }:

haskellPackagesNew: haskellPackagesOld:
let
  srcFilter =
    path: pkgs_old.lib.sourceFilesBySuffices
            path [".hs" "LICENSE" "cabal" ".c"];
  alterSrc = pkg: path: pkg.overrideDerivation (_: {
    src = srcFilter path;
  });
in {
  saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);
  crucible   =
    haskellPackagesOld.crucible.overrideDerivation
      (oldAttrs: {
        src = pkgs_old.lib.sourceFilesBySuffices
                ../crucible/crucible [".hs" "LICENSE" "cabal" ".c"];
        postUnpack = null;
        doCheck    = false;
      });
}
