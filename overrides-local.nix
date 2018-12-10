# Overrides for using local versions of sources.
# Good for hacking on multiple parts of the package set.
{ pkgsOld  ? import ./pinned-pkgs.nix { }
, compiler ? "ghc843"
}:

haskellPackagesNew: haskellPackagesOld:
let
  srcFilter =
    path: pkgsOld.lib.sourceFilesBySuffices
            path [".hs" "LICENSE" "cabal" ".c"];
  alterSrc = pkg: path: pkg.overrideDerivation (_: {
    src = srcFilter path;
  });
  dontCheck = pkg: pkg.overrideDerivation (_: { doCheck = false; });

  maybeSuffix = suffix: if suffix == "" then "" else "-" + suffix;

in {
  # crucible       = alterSrc haskellPackagesOld.crucible (../crucible);
  # crucible-llvm  = alterSrc haskellPackagesOld.crucible-llvm (../crucible);
  # saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);

  llvm-pretty-bc-parser = alterSrc haskellPackagesOld.llvm-pretty-bc-parser (../llvm-pretty-bc-parser);

  # Trying crucible-syntax (needs newer megaparsec than in nixpkgs)
  # what4 = alterSrc haskellPackagesOld.what4 (../crucible/what4);
  # crucible = haskellPackagesNew.callCabal2nix "crucible" ../crucible/crucible { };
  # crucible-syntax  = alterSrc haskellPackagesOld.crucible-syntax (../crucible/crucible-syntax);

  # The tests for this one just take forever
  #llvm-verifier = dontCheck haskellPackagesOld.llvm-verifier;

  # crucible-llvm  =
  #   haskellPackagesOld.crucible-llvm.overrideDerivation
  #     (oldAttrs: {
  #       src = pkgs_old.lib.sourceFilesBySuffices
  #               ../crucible/crucible-llvm [".hs" "LICENSE" "cabal" ".c"];
  #       postUnpack = null;
  #       doCheck    = false;
  #     });
}
