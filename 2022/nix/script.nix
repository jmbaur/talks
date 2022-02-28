{ writeShellApplication, hello }:
writeShellApplication {
  name = "hello-world";
  runtimeInputs = [ hello ];
  text = ''
    ${hello}/bin/hello --greeting $USER
  '';
}
