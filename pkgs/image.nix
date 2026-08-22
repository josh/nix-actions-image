{
  callPackage,
  dockerTools,
}:
let
  env = callPackage ./env.nix { };
  root = callPackage ./root.nix { };
in
dockerTools.streamLayeredImage {
  name = "nix-actions-image";
  tag = "latest";
  maxLayers = 80;
  includeNixDB = true;

  contents = [
    env
    root
  ];

  extraCommands = ''
    mkdir -p usr && ln -s ../bin usr/bin
    mkdir -m 1777 -p tmp
    mkdir -m 1777 -p var/tmp
    mkdir -m 0700 -p root
    mkdir -m 0777 -p github
    mkdir -m 0755 -p run/nix-actions
    : > run/nix-actions/built-paths
  '';

  config = {
    Cmd = [ "/bin/bash" ];
    Env = [
      "PATH=/root/.nix-profile/bin:/bin:/usr/bin"
      "HOME=/root"
      "USER=root"
      "LANG=C.UTF-8"
      "PAGER=cat"
      "NIX_BUILT_PATHS_FILE=/run/nix-actions/built-paths"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
    ];
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/josh/nix-actions-image";
      "org.opencontainers.image.licenses" = "MIT";
      "org.opencontainers.image.description" =
        "Slim Nix + flakes job image for Gitea, GitHub, and act runners.";
    };
  };
}
