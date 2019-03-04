{ pkgs ? import ./pinned-pkgs.nix { path = ./json/nixpkgs/master.json; }
}:
pkgs.stdenv.mkDerivation rec {
  name = "available-ghc-versions";

  shellHook = ''
    set -eu

    # echo "~monadmock: ''${pkgs.haskellPackages.~monadmock.version}"
    echo "aeson: ${pkgs.haskellPackages.aeson.version}"
    echo "doctest: ${pkgs.haskellPackages.doctest.version}"
    echo "monad-mock: ${pkgs.haskellPackages.monad-mock.version}"
    echo "haddock-api: ${pkgs.haskellPackages.haddock-api.version}"
    echo "haddock-library: ${pkgs.haskellPackages.haddock-library.version}"
    echo "lens: ${pkgs.haskellPackages.lens.version}"
    echo "tasty: ${pkgs.haskellPackages.tasty.version}"
    echo "tasty-html: ${pkgs.haskellPackages.tasty-html.version}"
    echo "tasty-hunit: ${pkgs.haskellPackages.tasty-hunit.version}"
    echo "tasty-quickcheck: ${pkgs.haskellPackages.tasty-quickcheck.version}"
    echo "turtle: ${pkgs.haskellPackages.turtle.version}"
    echo "megaparsec: ${pkgs.haskellPackages.megaparsec.version}"
    echo "versions: ${pkgs.haskellPackages.versions.version}"
    exit
  '';
}
