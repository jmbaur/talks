{ stdenv }:
stdenv.mkDerivation {
  name = "simple-derivation";
  src = ./.;
  installPhase = ''
    echo "hello, world" > $out
  '';
}
