#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

git switch main
version=$(nix eval --raw --inputs-from . 'nixpkgs#lib.version')
git commit --allow-empty --message "nix-actions-image $version"
git tag "$version"
