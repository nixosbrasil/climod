{ lib, ... }:
let
  inherit (lib) mkOption types;
in {
  imports = [
    ./options
  ];
  options = {
    target.docs = mkOption {
      description = "Generated docs";
      type = types.attrsOf types.anything;
      default = {};
      internal = true;
    };
  };
}
