let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  packages = with pkgs; [
    npins
    nixfmt-rfc-style
    deadnix
    statix
  ];
}
