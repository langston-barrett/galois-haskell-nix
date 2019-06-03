{ mkDerivation, aeson, algebraic-graphs, ansi-terminal, array
, async, attoparsec, base, bifunctors, bytestring, cmark-gfm
, containers, criterion, cryptohash, deepseq, directory
, directory-tree, fastsum, fetchgit, filepath, free, freer-cofreer
, fused-effects, fused-effects-exceptions, generic-monoid, ghc-prim
, gitrev, Glob, hashable, haskeline, haskell-tree-sitter, hostname
, hscolour, hspec, hspec-core, hspec-expectations-pretty-diff
, http-client, http-client-tls, http-media, http-types, HUnit, kdt
, leancheck, lens, machines, mersenne-random-pure64, mtl, network
, network-uri, optparse-applicative, parallel, parsers, pretty-show
, prettyprinter, process, profunctors, proto3-suite, proto3-wire
, recursion-schemes, reducers, safe-exceptions, scientific
, semigroupoids, semilattices, servant, shelly, split, stdenv
, stm-chans, template-haskell, temporary, text, these, time
, tree-sitter-go, tree-sitter-haskell, tree-sitter-java
, tree-sitter-json, tree-sitter-php, tree-sitter-python
, tree-sitter-ruby, tree-sitter-typescript, unix, unliftio-core
, unordered-containers, vector
}:
mkDerivation {
  pname = "semantic";
  version = "0.6.0";
  src = fetchgit {
    url = "https://github.com/github/semantic.git";
    sha256 = "0kjx9crx3rpcj4bv1a1alr7gwavx2csq1ddhplqqks82xmjrcs0i";
    rev = "07fb2cb8a6b0f4270b37abc006302b664e6c3c23";
    fetchSubmodules = false;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson algebraic-graphs ansi-terminal array async attoparsec base
    bifunctors bytestring cmark-gfm containers cryptohash deepseq
    directory directory-tree fastsum filepath free freer-cofreer
    fused-effects fused-effects-exceptions generic-monoid ghc-prim
    gitrev hashable haskeline haskell-tree-sitter hostname hscolour
    http-client http-client-tls http-media http-types kdt lens machines
    mersenne-random-pure64 mtl network network-uri optparse-applicative
    parallel parsers pretty-show prettyprinter process profunctors
    proto3-suite proto3-wire recursion-schemes reducers safe-exceptions
    scientific semigroupoids semilattices servant shelly split
    stm-chans template-haskell text these time tree-sitter-go
    tree-sitter-haskell tree-sitter-java tree-sitter-json
    tree-sitter-php tree-sitter-python tree-sitter-ruby
    tree-sitter-typescript unix unliftio-core unordered-containers
    vector
  ];
  executableHaskellDepends = [
    aeson algebraic-graphs async base bifunctors bytestring containers
    directory fastsum filepath free fused-effects
    fused-effects-exceptions hashable haskell-tree-sitter machines mtl
    network process proto3-suite proto3-wire recursion-schemes
    safe-exceptions scientific semilattices text these unix
  ];
  testHaskellDepends = [
    aeson algebraic-graphs async base bifunctors bytestring containers
    directory fastsum filepath free fused-effects
    fused-effects-exceptions Glob hashable haskell-tree-sitter hspec
    hspec-core hspec-expectations-pretty-diff HUnit leancheck machines
    mtl network process proto3-suite proto3-wire recursion-schemes
    safe-exceptions scientific semilattices temporary text these
    tree-sitter-json unix
  ];
  benchmarkHaskellDepends = [ base criterion ];
  homepage = "http://github.com/github/semantic-open-source#readme";
  description = "Framework and service for analyzing and diffing untrusted code";
  license = stdenv.lib.licenses.mit;
}
