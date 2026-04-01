let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
  wallpapers = pkgs.callPackage ./packages/wallpapers { };
in
{
  inherit wallpapers;
  default = wallpapers;
}
