{ mkShell, awscli2, nodejs-16_x, go_1_17 }:
mkShell {
  buildInputs = [ awscli2 nodejs-16_x go_1_17 ];
  FOO = "bar";
  shellHook = ''
    echo hello world
  '';
}
