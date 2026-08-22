{
  lib,
  runCommand,
}:
runCommand "image-root"
  {
    rev = lib.trivial.revisionWithDefault (
      throw "nixpkgs revision unavailable; cannot pin the flake registry"
    );
  }
  ''
    mkdir -p "$out"
    cp -R ${../root}/etc "$out/"
    chmod -R u+w "$out"
    chmod 0755 "$out/etc/nix/post-build-hook"
    substituteInPlace "$out/etc/nix/registry.json" --replace-fail "@rev@" "$rev"
  ''
