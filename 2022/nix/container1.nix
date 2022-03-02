{ dockerTools, busybox }:
dockerTools.buildImage {
  name = "hello-world";
  tag = "latest";
  contents = [ busybox ];
  config.Cmd = [ "/bin/sh" ];
}
