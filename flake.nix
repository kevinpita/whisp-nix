{
  description = "Nix flake for Whisp, the Anti-Note for GNOME, built from source without Flatpak";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    let
      overlay = final: prev: {
        whisp = final.callPackage ./package.nix { };
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        packages = {
          default = pkgs.whisp;
          whisp = pkgs.whisp;
        };

        apps = {
          default = {
            type = "app";
            program = "${pkgs.whisp}/bin/whisp";
          };
          whisp = {
            type = "app";
            program = "${pkgs.whisp}/bin/whisp";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gh
            jq
            nixpkgs-fmt
          ];
        };
      }
    )
    // {
      overlays.default = overlay;
    };
}
