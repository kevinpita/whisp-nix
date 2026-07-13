# whisp-nix

Always up-to-date Nix package for [Whisp](https://github.com/tanaybhomia/Whisp), the Anti-Note for GNOME: a fluid, gesture-driven scratchpad built for speed.

Built from source with Meson and GTK4/libadwaita, so there is no Flatpak runtime involved.

## Quick Start

```bash
nix run github:kevinpita/whisp-nix
```

## Install

```bash
nix profile install github:kevinpita/whisp-nix
```

## Use In A Flake

```nix
{
  inputs.whisp-nix.url = "github:kevinpita/whisp-nix";

  outputs = { whisp-nix, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          whisp-nix.packages.${system}.default
        ];
      };
    };
}
```

You can also pull in the overlay to get `pkgs.whisp`:

```nix
nixpkgs.overlays = [ whisp-nix.overlays.default ];
```

## Development

```bash
nix build .#whisp
test -f ./result/bin/whisp
```

## Updates

The update workflow checks upstream releases hourly and can also be run manually from GitHub Actions. When a new release exists, it updates `package.nix`, refreshes the source hash, updates `flake.lock`, creates a pull request, and enables auto-merge.

Manual update:

```bash
./scripts/update.sh --check
./scripts/update.sh --version 1.3.7
```
