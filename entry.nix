{ lib
, writeShellScript
, pkgs
}:
config:
let
  inherit (lib) types;
  module = lib.evalModules {
    modules = [
      config
      ./modules
    ];
    specialArgs = {
      inherit pkgs;
    };
  };
  out = module.config.target.bash.drv;
in out.overrideAttrs (_: {
  passthru = {
    inherit (module) config options;
    inherit module;
  };
})
