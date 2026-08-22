{
  buildEnv,
  pkgs,
}:
buildEnv {
  name = "image-env";
  pathsToLink = [
    "/bin"
    "/etc"
    "/lib"
    "/share"
  ];
  paths = with pkgs; [
    # keep-sorted start
    bashInteractive
    cacert
    coreutils
    curl
    findutils
    gitMinimal
    gnugrep
    gnused
    gnutar
    gzip
    iana-etc
    jq
    nix
    nodejs-slim
    openssh
    which
    xz
    # keep-sorted end
  ];
}
