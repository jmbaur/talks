{ stdenv }:
stdenv.mkDerivation {
  name = "simple-derivation";
  src = ./.;
  installPhase = ''
    echo "foobar" > $out
  '';
}
