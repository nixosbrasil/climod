{lib, config, pkgs, shellcheck, ...}:
let
  inherit (lib) mkOption types;
in
  {
    options = {
      target.bash.drv = mkOption {
        type = types.package;
        description = "Package using the shell script version as a binary";
      };
    };
    config.target.bash.drv = pkgs.stdenv.mkDerivation {
      inherit (config) name;
      inherit (config.target.bash) code;

      dontUnpack = true;

      installPhase = ''
          mkdir $out/bin -p
          echo "$code" > $out/bin/$name
          chmod +x $out/bin/$name
      '';

      checkInputs = [ shellcheck ];
      checkPhase = ''
          shellcheck $out/bin/$name
      '';
    };
  }
