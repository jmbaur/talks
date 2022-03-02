{ writeShellApplication, hello }:
writeShellApplication {
  name = "hello-world";
  runtimeInputs = [ hello ];
  # missing quotes around $USER
  text = ''
    ${hello}/bin/hello --greeting $USER
  '';
}
