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

  # llvm-pretty = alterSrc haskellPackagesOld.llvm-pretty (../llvm-pretty-bc-parser/llvm-pretty);
  # llvm-pretty-bc-parser = alterSrc haskellPackagesOld.llvm-pretty-bc-parser (../llvm-pretty-bc-parser);

  # crucible      = alterSrc haskellPackagesOld.crucible (../crucible/crucible);
  # crucible-llvm = alterSrc haskellPackagesOld.crucible-llvm (../crucible/crucible-llvm);
  # crucible-jvm = alterSrc haskellPackagesOld.crucible-jvm (../crucible/crucible-jvm);
  saw-script     = alterSrc haskellPackagesOld.saw-script (../saw-script);
  # what4          = haskellPackagesOld.what4.overrideAttrs (oldAttrs: {
  #   src = srcFilter (../crucible/what4);
  #   propagatedBuildInputs =
  #     oldAttrs.propagatedBuildInputs ++ [ haskellPackagesOld.deriving-compat ];
  # });

  # parameterized-utils = alterSrc haskellPackagesOld.parameterized-utils (../parameterized-utils);

  # macaw-symbolic =
  #   alterSrcJSON haskellPackagesOld.macaw-symbolic "macaw" ./json/macaw.json;
  # saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);
  # saw-core = alterSrc haskellPackagesOld.saw-core (../saw-core);
  # saw-script = alterSrc haskellPackagesOld.saw-script (../saw-script);
  # llvm-verifier = alterSrc haskellPackagesOld.llvm-verifier (../llvm-verifier);

  # Trying crucible-syntax (needs newer megaparsec than in nixpkgs)
  # crucible-syntax  = alterSrc haskellPackagesOld.crucible-syntax (../crucible/crucible-syntax);
}
//

# The Macaw suite
{
  macaw-base         = alterSrc haskellPackagesOld.macaw-base (../macaw/base);
  macaw-symbolic     = alterSrc haskellPackagesOld.macaw-symbolic (../macaw/symbolic);
  macaw-x86-symbolic = alterSrc haskellPackagesOld.macaw-x86-symbolic (../macaw/x86_symbolic);
  macaw-x86          = alterSrc haskellPackagesOld.macaw-x86 (../macaw/x86);
}
