let
  pkgs = import <nixpkgs> {};
in pkgs.callPackage ./entry.nix {}
