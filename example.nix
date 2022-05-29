import ./default.nix {
  name = "demo";
  language = "bash";
  description = "Demo CLI generated";
  action = ''
    echo Hello, world
  '';
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
          action = "echo Hello, $GREET_USER!";
        };
      };
    };
  };
}
