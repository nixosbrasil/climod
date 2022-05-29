{ lib
, writeShellScript
}:
config:
let
  inherit (lib) types;
  module = lib.evalModules {
    modules = [
      config
      ./modules
    ];
  };
in (writeShellScript module.config.name module.config.target.shellscript).overrideAttrs (_: {
  passthru = {
    inherit (module) config options;
    inherit module;
  };
})
