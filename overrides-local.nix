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
  dontCheck = pkg: pkg.overrideDerivation (_: { doCheck = false; });
in {
  saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);

  llvm-pretty-bc-parser = alterSrc haskellPackagesOld.llvm-pretty-bc-parser (../llvm-pretty-bc-parser);

  # The tests for this one just take forever
  llvm-verifier = dontCheck haskellPackagesOld.llvm-verifier;

  # crucible-llvm  =
  #   haskellPackagesOld.crucible-llvm.overrideDerivation
  #     (oldAttrs: {
  #       src = pkgs_old.lib.sourceFilesBySuffices
  #               ../crucible/crucible-llvm [".hs" "LICENSE" "cabal" ".c"];
  #       postUnpack = null;
  #       doCheck    = false;
  #     });
}
