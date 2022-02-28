{
  description = "Nix presentation";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        texlive = pkgs.texlive.combined.scheme-medium;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            texlive
            (pkgs.writeShellScriptBin "run" ''
              ${texlive}/bin/latexmk -pdf -pvc -view=none presentation.tex
            '')
          ];
        };
        packages.simple-derivation = pkgs.callPackage ./simple-derivation.nix { };
        packages.simple-derivation-modded = pkgs.callPackage ./simple-derivation-modded.nix { };
        packages.script = pkgs.callPackage ./script.nix { };
        packages.container = pkgs.callPackage ./container.nix { };
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
      });
}
