# Copied from https://gitlab-int.galois.com/binary-analysis/nixbuilds/raw/master/saw/abc.nix
{ fetchgit, stdenv, pkgs, ...
# , ghcver ? "ghc822"
# , projpkgs ? (import ./saw-project.nix { inherit ghcver; })
}:

stdenv.mkDerivation rec {
  name = "abc-${version}";
  version = "20160826";

  # src = fetchhg {
  #   url    = "https://bitbucket.org/alanmi/abc";
  #   rev    = "a2e5bc66a68a72ccd267949e5c9973dd18f8932a";
  #   sha256 = "09yvhj53af91nc54gmy7cbp7yljfcyj68a87494r5xvdfnsj11gy";
  # };

  src = fetchgit {
    url = "https://github.com/berkeley-abc/abc";
    rev = "2c73723";  # master
    sha256 = "0p0lcg20lbr2lzjv6b262592vji334ybk78x5gx6azpy18nxiy3g";
  };

  buildInputs = [ ];
  preBuild = ''
    export buildFlags="CC=$CC CXX=$CXX LD=$CXX ABC_USE_NO_READLINE=1 libabc.a"
  '';

  # n.b. the following are documented, but libabc.so is not a valid make target:
  # ABC_USE_PIC=1 libabc.so

  enableParallelBuilding = true;
  installPhase = ''
    mkdir -p $out/lib
    mv libabc.a $out/lib/
    # mv libabc.so $out/lib
    mkdir -p $out/include
    for I in $(cd $src/src; find . -name '*.h') ; do
      if [ $(basename $I) != "main.h" -o $(basename $(dirname $I)) != "espresso" ] ; then
        mkdir -p $out/include/$(dirname $I)
        # cp $src/src/$I $out/include/$(basename $I | sed s,./,,) || echo "skipped $(basename $I)"
        cp $src/src/$I $out/include/$(echo $I | sed s,./,,) || echo "skipping $I"
      fi
    done

    # cp $src/src/misc/util/abc_global.h $out/include/abc_global.h
    # cp $src/src/misc/util/abc_namespaces.h $out/include/abc_namespaces.h
    # mkdir -p $out/include/misc/util
    # cp $src/src/misc/util/abc_global.h $out/include/misc/util/abc_global.h
    # cp $src/src/misc/vec/vec.h $out/include/vec.h
    # mkdir -p $out/include/misc/vec
    # cp $src/src/misc/vec/vec.h $out/include/misc/vec/vec.h
    # cp $src/src/base/abc/abc.h $out/include/abc.h
  '';

  meta = {
    description = "A tool for sequential logic synthesis and formal verification";
    homepage    = "https://people.eecs.berkeley.edu/~alanmi/abc/abc.htm";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [thoughtpolice kquick];
  };
}
