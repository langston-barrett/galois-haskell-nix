# * Haskell code explorer
#
# Index a package with the [[https://github.com/alexwl/haskell-code-explorer][Haskell code explorer]]
#
# We can't do this as a derivation, because Cabal has too many network requests:
# https://github.com/haskell/cabal/issues/5363
#
# Be sure to use ~nix-shell --pure~!
{ pkgs  ? import ./pinned-pkgs.nix { }
, gpkgs ? import ./default.nix { }
, names ? [
  "crucible"
  "crucible-llvm"
  "llvm-pretty"
  "llvm-pretty-bc-parser"
  "parameterized-utils"
  "what4"
]
}:

let
  these = map (name: gpkgs.haskellPackages.${name}) names;
  each  = f: map f these;
  ghcWP = gpkgs.haskellPackages.ghcWithPackages (hpkgs: with hpkgs; [
    # Cabal_2_2_0_1 # doesn't help?
  ] ++ pkgs.lib.concatLists (each (this: this.buildInputs))
    ++ pkgs.lib.concatLists (each (this: this.propagatedBuildInputs)));
  ghcPkgConf = ghcWP + "/lib/ghc-8.4.3/package.conf.d";
in with pkgs; stdenv.mkDerivation {
  name         = "galois-code-exporer";
  src          = null;
  buildInputs  = [
    ghcWP
    haskellPackages.cabal-install
    gpkgs.haskellPackages.haskell-code-explorer
  ];
  shellHook    =
    let root = "/run/user/1000/code-explorer/";
    in ''
    # Save space and time be reusing the home directory
    root=${root}      && mkdir -p "$root" && cd "$root"
    home=$root/home   && mkdir -p "$home"
    export HOME=$home

    for path in ${lib.concatStringsSep " " (each (this: this.src))}; do
      cabal=$(basename $(ls $path/*.cabal))
      name=''${cabal%.*}
      echo "Copying source of $name to $root$name"
      cp -a "$path" "$root/$name" &> /dev/null
      chmod 0750 "$root/$name"
    done

    cabal update

    declare -a flags
    for path in ${lib.concatStringsSep " " these}; do
      # We do some weird bash parameter substitution to find the name from the
      # path. The double quote escapes the $ { }
      name0=''${path%-*}
      name=''${name0#*-}

      echo "Building $name..."

      # Build the package
      dir=$root/$name && mkdir -p "$dir" && cd "$dir"
      if ! [[ -d $(pwd)/dist ]]; then
        cabal configure && cabal build
      fi

      # Index the package
      if ! [[ -d $(pwd)/.haskell-code-explorer ]]; then
        if haskell-code-indexer -p "$(pwd)" \
                                --dist dist/ \
                                --ghc "-package-db ${ghcPkgConf}"; then
          flags+=( "--package $name" )
        fi
      else
        flags+=( "--package $name" )
      fi
    done

    # Run the server
    cd $root
    pkill haskell-code-se
    haskell-code-server ''${flags[*]}
  '';
}
