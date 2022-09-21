{ pkgs ? import <nixpkgs> {} }:
let
  climod = pkgs.callPackage ./default.nix { inherit pkgs; };
in climod {
  name = "demo";
  description = "Demo CLI generated";
  target.bash.prelude = ''
    echo "Starting..."
  '';
  action.bash = ''
    echo Hello, world
    echo $#
    while [ $# -gt 0 ]; do
      echo "$1"
      shift
    done
  '';
  allowExtraArguments = true;
  subcommands = {
    args = {
      description = "Print args";
      allowExtraArguments = true;
      action.bash = ''
        for line in "$@"; do
          echo $line
        done
      '';
    };
    eoq = {
      description = "Eoq subcommand";
      subcommands = {
        greet = {
          description = "Greets the user";
          flags = [
            {
              description = "User name";
              keywords = ["-n" "--name" ];
              variable = "GREET_USER";
            }
          ];
          action.bash = "echo Hello, $GREET_USER!";
        };
      };
    };
  };
}
