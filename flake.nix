{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      packages = lib.genAttrs systems (system: {
        image = nixpkgs.legacyPackages.${system}.callPackage ./pkgs/image.nix { };
        default = self.packages.${system}.image;
      });

      checks = lib.genAttrs systems (system: {
        inherit (self.packages.${system}) image;
      });
    };
}
