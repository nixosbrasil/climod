{ pkgs ? import <nixpkgs> {} }:
let climod = pkgs.callPackage ./default.nix { inherit pkgs; };
in  climod {
  name = "demo";
  description = "Demo CLI generated";
  action.bash = ''
    echo Hello, world
    echo $#
    while [ $# -gt 0 ]; do
      echo "$1"
      shift
    done
  '';
  target.bash.prelude = ''
    echo "Starting..."
  '';
  allowExtraArguments = true;
  subcommands.args.description = "Print args";
  subcommands.args.allowExtraArguments = true;
  subcommands.args.action.bash = ''
    for line in "$@"; do
      echo $line
    done
  '';
  subcommands.eoq.description = "Eoq subcommand";
  subcommands.eoq.subcommands.greet.description = "Greets the user";
  subcommands.eoq.subcommands.greet.action.bash = "echo Hello, $GREET_USER!";
  subcommands.eoq.subcommands.greet.flags = [
    {
      description = "User name";
      keywords    = ["-n" "--name" ];
      variable    = "GREET_USER";
    }
  ];  
}
