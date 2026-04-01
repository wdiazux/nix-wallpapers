# nix-wallpapers

A curated collection of wallpapers packaged as a Nix derivation. Includes anime art, digital illustrations, NixOS-themed backgrounds, and video wallpapers — all discoverable and installable through Nix.
## Usage

### Flakes

Add as a flake input:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-wallpapers.url = "github:wdiaz/nix-wallpapers";
  };

  outputs = { nixpkgs, nix-wallpapers, ... }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    wallpapers = nix-wallpapers.packages.x86_64-linux.wallpapers;
  in {
    # Use in NixOS configuration
    # environment.systemPackages = [ wallpapers ];

    # Or reference a single wallpaper
    # wallpapers.nixos-dark
  };
}
```

### npins

Add the pin:

```bash
npins add github wdiaz nix-wallpapers -b main
```

Then import it:

```nix
let
  sources = import ./npins;
  nix-wallpapers = import sources.nix-wallpapers;
in {
  # Full wallpaper set
  # environment.systemPackages = [ nix-wallpapers.wallpapers ];

  # Single wallpaper by name
  # nix-wallpapers.wallpapers.nixos-dark
}
```

### Traditional Nix

```nix
let
  nix-wallpapers = import (builtins.fetchTarball {
    url = "https://github.com/wdiaz/nix-wallpapers/archive/main.tar.gz";
  });
in {
  # environment.systemPackages = [ nix-wallpapers.wallpapers ];
}
```

## Individual wallpapers

Each wallpaper is available as its own derivation via `passthru` attributes. The attribute name is the filename without its extension:

```nix
let
  wallpapers = nix-wallpapers.packages.x86_64-linux.wallpapers;
in {
  # Single wallpaper derivation
  my-wallpaper = wallpapers.dracula-nixos;

  # List all available names
  all-names = wallpapers.names;
}
```

## Building locally

```bash
# With flakes
nix build .#wallpapers

# Without flakes
nix-build default.nix -A wallpapers
```

The output is at `result/share/wallpapers/`.

## Adding wallpapers

Drop image or video files into `packages/wallpapers/images/`. The package discovers them automatically — no Nix changes needed.

Supported formats include `.jpg`, `.png`, and `.mp4`.

## Development

Enter the dev shell for tooling (npins, nixfmt, deadnix, statix):

```bash
nix-shell
```

## Disclaimer

The wallpapers included in this repository were collected from various internet sources and are the property of their respective creators. They are provided here for personal use only. If you are the original author of any image and would like it removed, please open an issue.

## License

The Nix packaging code in this repository is licensed under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0). The wallpaper images and videos are not covered by this license and remain under the copyright of their original authors.
