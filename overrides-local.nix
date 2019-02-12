# * Local overrides
#
# Overrides for using local versions of sources.
# Good for hacking on multiple parts of the package set.
#
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

  # Add dependencies
  addDeps = pkg: path: deps: pkg.overrideAttrs (oldAttrs: {
    src = srcFilter path;
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ deps;
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

in with haskellPackagesOld; {
  # Use with auto-yasnippet (SPC i S c)
  # ~pkg = alterSrc ~pkg (../crucible/~pkg);
  saw-script     = alterSrc saw-script (../saw-script);
}
//

# ** Macaw

(with haskellPackagesOld; {
  # macaw-base         = alterSrc macaw-base (../macaw/base);
  # macaw-symbolic     = alterSrc macaw-symbolic (../macaw/symbolic);
  # macaw-x86-symbolic = alterSrc macaw-x86-symbolic (../macaw/x86_symbolic);
  # macaw-x86          = alterSrc macaw-x86 (../macaw/x86);
})
//

# ** Crucible

(with haskellPackagesOld; {
  # crucible            = alterSrc crucible (../crucible/crucible);
  # crucible-llvm       = alterSrc crucible-llvm (../crucible/crucible-llvm);
  crucible-llvm       = addDeps crucible-llvm (../crucible/crucible-llvm) [itanium-abi];
  # crucible-jvm        = alterSrc crucible-jvm (../crucible/crucible-jvm);
  # crucible-saw        = alterSrc crucible-saw (../crucible/crucible-saw);
  # parameterized-utils = alterSrc parameterized-utils (../parameterized-utils);
  # what4               = addDeps what4 (../crucible/what4) [deriving-compat];
  # what4               = alterSrc what4 (../crucible/what4);
  crux-llvm           = alterSrc crux-llvm (../crucible/crux-llvm);
})
//

# ** llvm-pretty-*

(with haskellPackagesOld; {
  # llvm-pretty = alterSrc llvm-pretty (../llvm-pretty-bc-parser/llvm-pretty);
  # llvm-pretty-bc-parser = alterSrc llvm-pretty-bc-parser (../llvm-pretty-bc-parser);
})
