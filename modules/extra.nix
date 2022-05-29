{lib, config, ...}:
let
  inherit (lib) mkOption types;
  inherit (builtins) filter attrValues mapAttrs readDir trace;
in
{
  imports = [
    ({config, ...}: {
      options = {
        # target = mkOption {
        #   type = types.attrsOf types.anything;
        #   description = "Outputs";
        #   default = {};
        # };
        language = mkOption {
          # type = types.str;
          type = let
            formats = readDir ./.;
            formats' = mapAttrs (k: v: if v == "directory" then k else null) formats;
            formats'' = attrValues formats';
            formats''' = filter (v: v != null) formats'';
          in types.enum formats''';
          description = "Programming language that will be generated";
        };
      };
    })
  ];
}
