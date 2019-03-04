{ hlib
, buildType ? "fast"
}:

let disableOptimization = pkg: hlib.appendConfigureFlag pkg "--disable-optimization"; # In newer nixpkgs
    wrappers = rec {
      nocov            = x: hlib.dontCoverage x;
      noprof           = x: hlib.disableExecutableProfiling (hlib.disableLibraryProfiling (nocov x));
      # noprof           = x: x;
      notest           = x: hlib.dontCheck (noprof x);
      exe              = x: hlib.justStaticExecutables (wrappers.default x);
      jailbreak        = x: hlib.doJailbreak x;
      jailbreakDefault = x: wrappers.jailbreak (wrappers.default x);
      #
      fast    = x: disableOptimization (notest x);
      good    = x: hlib.dontCheck (nocov x);
      default = wrappers.${buildType};
    };
in wrappers
