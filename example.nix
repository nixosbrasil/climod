import ./default.nix {
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
