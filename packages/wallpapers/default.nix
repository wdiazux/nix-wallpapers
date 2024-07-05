{
  pkgs,
  lib,
  ...
}: let
  images = builtins.attrNames (builtins.readDir ./images);
  names = builtins.map (lib.snowfall.path.get-file-name-without-extension) images;
  installTarget = "$out/share/wallpapers";

  mkWallpaper = name: src:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name src;
      dontUnpack = true;
      installPhase = ''
        install -Dm 644 $src $out
      '';
      passthru.fileName = builtins.baseNameOf src;
    };

  wallpapers = builtins.listToAttrs (map (image:
    let
      name = lib.snowfall.path.get-file-name-without-extension image;
    in
      {
        inherit name;
        value = mkWallpaper name (./images + "/${image}");
      }
  ) images);
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "plusultra-wallpapers";
    src = ./images;

    installPhase = ''
      mkdir -p ${installTarget}
      install -Dm 644 $src/* $installTarget
    '';

    passthru = {inherit names;} // wallpapers;

    meta = with lib; {
      description = "Some good wallpapers!";
      license = licenses.asl20;
      maintainers = with maintainers; [wdiaz];
    };
  }
