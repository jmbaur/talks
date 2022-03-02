{ dockerTools, runCommand }:
let
  slow1 = runCommand "slow1" { } ''
    sleep 10
    mkdir -p $out && touch $out/slow1
  '';
  slow2 = runCommand "slow2" { } ''
    sleep 10
    mkdir -p $out && touch $out/slow2
  '';
in
dockerTools.buildImage {
  name = "hello-world";
  tag = "latest";
  contents = [ slow1 slow2 ];
}
