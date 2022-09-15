{ pkgs ? import <nixpkgs> {}
}:
pkgs.callPackage ./entry.nix {}
