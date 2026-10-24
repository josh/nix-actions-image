{
  lib,
  runCommand,
}:
let
  buildUsers = lib.range 1 32;
in
runCommand "image-root"
  {
    rev = lib.trivial.revisionWithDefault (
      throw "nixpkgs revision unavailable; cannot pin the flake registry"
    );
    passwd = lib.concatMapStrings (
      n:
      "nixbld${toString n}:x:${toString (30000 + n)}:30000:Nix build user ${toString n}:/var/empty:/bin/sh\n"
    ) buildUsers;
    group = "nixbld:x:30000:${lib.concatMapStringsSep "," (n: "nixbld${toString n}") buildUsers}\n";
  }
  ''
    mkdir -p "$out"
    cp -R ${../root}/etc "$out/"
    chmod -R u+w "$out"
    chmod 0755 "$out/etc/nix/post-build-hook"
    substituteInPlace "$out/etc/nix/registry.json" --replace-fail "@rev@" "$rev"
    printf '%s' "$passwd" >>"$out/etc/passwd"
    printf '%s' "$group" >>"$out/etc/group"
  ''
