with import <nixpkgs> {};

mkShell rec {
  buildInputs = [ yarn elmPackages.elm ];

  shellHook = ''
    export ELM_MAKE=${elmPackages.elm}/bin/elm-make
    export PATH="`pwd`/node_modules/.bin:$PATH"
  '';
}
