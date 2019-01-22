# Overrides for using local versions of sources.
# Good for hacking on multiple parts of the package set.
{ pkgsOld  ? import ./pinned-pkgs.nix { }
, compiler # ? "ghc844"
}:

haskellPackagesNew: haskellPackagesOld:
let
  srcFilter =
    path: pkgsOld.lib.sourceFilesBySuffices
            path [".hs" "LICENSE" "cabal" ".c" ".sawcore"];

  # Give an explicit path for a new source
  alterSrc = pkg: path: pkg.overrideDerivation (_: {
    src = srcFilter path;
  });

  # Change the JSON file used for the source fetching
  # Doesn't quite work.
  alterSrcJSON = pkg: name: json: alterSrc pkg
    (let fromJson = builtins.fromJSON (builtins.readFile json);
    in pkgsOld.fetchFromGitHub {
         owner = "GaloisInc";
         repo  = name;
         inherit (fromJson) rev sha256;
       });

  dontCheck = pkg: pkg.overrideDerivation (_: { doCheck = false; });

  maybeSuffix = suffix: if suffix == "" then "" else "-" + suffix;

in {
  # crucible       = alterSrc haskellPackagesOld.crucible (../crucible);

  llvm-pretty = alterSrc haskellPackagesOld.llvm-pretty (../llvm-pretty-bc-parser/llvm-pretty);
  llvm-pretty-bc-parser = alterSrc haskellPackagesOld.llvm-pretty-bc-parser (../llvm-pretty-bc-parser);
  crucible-llvm  = alterSrc haskellPackagesOld.crucible-llvm (../crucible/crucible-llvm);
  macaw-symbolic  = alterSrc haskellPackagesOld.macaw-symbolic (../macaw/symbolic);
  saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);

  # macaw-symbolic =
  #   alterSrcJSON haskellPackagesOld.macaw-symbolic "macaw" ./json/macaw.json;
  # saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);
  # saw-core = alterSrc haskellPackagesOld.saw-core (../saw-core);
  # saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);
  # llvm-verifier = alterSrc haskellPackagesOld.llvm-verifier (../llvm-verifier);

  # Trying crucible-syntax (needs newer megaparsec than in nixpkgs)
  # what4 = alterSrc haskellPackagesOld.what4 (../crucible/what4);
  # crucible = haskellPackagesNew.callCabal2nix "crucible" ../crucible/crucible { };
  # crucible-syntax  = alterSrc haskellPackagesOld.crucible-syntax (../crucible/crucible-syntax);


  # crucible-llvm  =
  #   haskellPackagesOld.crucible-llvm.overrideDerivation
  #     (oldAttrs: {
  #       src = pkgs_old.lib.sourceFilesBySuffices
  #               ../crucible/crucible-llvm [".hs" "LICENSE" "cabal" ".c"];
  #       postUnpack = null;
  #       doCheck    = false;
  #     });
}
