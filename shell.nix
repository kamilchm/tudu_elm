with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "tudu-dev-shell";
  
  buildInputs = [ yarn elmPackages.elm ];

  shellHook = ''
    export ELM_MAKE=${elmPackages.elm}/bin/elm-make
  '';
}
