# nix-actions-image

A slim OCI image with Nix and flakes preinstalled, for Actions jobs that build with Nix. It carries
everything the runners actually exec — `/bin/sleep`, `bash`, `node`, `git` — so it works as a Gitea
Actions runner label target, as a `container:` image on GitHub Actions, and as a `nektos/act`
platform image. No cache, substituter, or credential is baked in; supply those per job via
`NIX_CONFIG`. Built with `dockerTools.streamLayeredImage`, so the digest changes only when the
inputs do.

## Usage

Point a Gitea runner label at the image:

```
nix-x86_64-linux:docker://ghcr.io/josh/nix-actions-image
```

```yaml
name: Nix
on: push

jobs:
  check:
    runs-on: nix-x86_64-linux
    steps:
      - uses: actions/checkout@v4
      - run: nix flake check --keep-going --print-build-logs
```
