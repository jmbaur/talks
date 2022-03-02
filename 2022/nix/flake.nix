{
  description = "Nix presentation";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          texlive = pkgs.texlive.combined.scheme-medium;
        in
        {
          devShells.example = pkgs.callPackage ./dev-env.nix { };
          devShells.default = pkgs.mkShell {
            buildInputs = [
              texlive
              (pkgs.writeShellScriptBin "run" ''
                ${texlive}/bin/latexmk -pdf -pvc -view=none presentation.tex
              '')
            ];
          };
          devShell = self.devShells.${system}.default;
          packages.simple-derivation = pkgs.callPackage ./simple-derivation.nix { };
          packages.script = pkgs.callPackage ./script.nix { };
          packages.container1 = pkgs.callPackage ./container1.nix { };
          packages.container2 = pkgs.callPackage ./container2.nix { };
          packages.nixos-test = pkgs.callPackage ./nixos-test.nix { };
          packages.fetch = pkgs.callPackage ./fetch.nix { };
          packages.fetch-repro = pkgs.callPackage ./fetch-repro.nix { };
          packages.presentation = pkgs.stdenvNoCC.mkDerivation {
            pname = "nix-presentation";
            version = "2022-03-02";
            src = builtins.path { path = ./.; };
            buildPhase = ''
              ${texlive}/bin/latexmk -pdf presentation.tex
            '';
            installPhase = ''
              cp presentation.pdf $out
            '';
          };
          defaultPackage = self.packages.${system}.presentation;
        }) // {
      nixosConfigurations.example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-config.nix
          ({
            boot.loader.grub.device = "/dev/sda";
            fileSystems."/" = {
              device = "/dev/sda";
              fsType = "ext4";
            };
            users.users.jared = {
              isNormalUser = true;
              initialPassword = "helloworld";
            };
          })
        ];
      };
    };
}
