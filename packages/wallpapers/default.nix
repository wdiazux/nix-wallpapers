{
  lib,
  stdenvNoCC,
}:
let
  images = builtins.attrNames (builtins.readDir ./images);

  removeExtension =
    name:
    let
      m = builtins.match "(.+)\\.[^.]+$" name;
    in
    if m != null then builtins.head m else name;

  names = builtins.map removeExtension images;
  installTarget = "$out/share/wallpapers";

  mkWallpaper =
    name: src:
    stdenvNoCC.mkDerivation {
      inherit name src;
      dontUnpack = true;
      installPhase = ''
        install -Dm 644 "$src" "$out"
      '';
      passthru.fileName = builtins.baseNameOf src;
    };

  wallpapers = builtins.listToAttrs (
    map (
      image:
      let
        name = removeExtension image;
      in
      {
        inherit name;
        value = mkWallpaper name (./images + "/${image}");
      }
    ) images
  );
in
stdenvNoCC.mkDerivation {
  pname = "nix-wallpapers";
  version = "0.1.0";
  src = ./images;

  installPhase = ''
    mkdir -p "${installTarget}"
    install -Dm 644 "$src"/* "${installTarget}"
  '';

  passthru = {
    inherit names;
  }
  // wallpapers;

  meta = {
    description = "Some good wallpapers!";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wdiaz ];
  };
}
