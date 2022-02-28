{ dockerTools, hello }:
dockerTools.buildImage {
  name = "hello-world";
  tag = "latest";
  config = {
    Cmd = [ "${hello}/bin/hello" ];
  };
}
