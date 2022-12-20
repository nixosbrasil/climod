{lib, config, pkgs, shellcheck, ...}:
let
  inherit (lib) mkOption types;
in
  {
    options = {
      target.bash.drv = mkOption {
        type = types.package;
        description = "Package using the shell script version as a binary";
        internal = true;
      };
    };
    config.target.bash.drv = pkgs.stdenv.mkDerivation {
      inherit (config) name;
      code = builtins.toFile "code" config.target.bash.code;

      dontUnpack = true;

      installPhase = ''
          mkdir $out/bin -p
          install -m 755 $code $out/bin/$name
      '';

      checkInputs = [ shellcheck ];
      checkPhase = ''
          shellcheck $out/bin/$name
      '';
      meta.mainProgram = config.name;
    };
  }
