{ lib
, config
, ...
}:
let
  inherit (lib) types mkOption;
  inherit (types) str strMatching attrsOf listOf submodule nullOr nonEmptyListOf bool;
  flag = submodule ({config, ...}: {
    options = {
      keywords = mkOption {
        type = nonEmptyListOf (strMatching "-[a-zA-Z0-9]|-(-[a-z0-9]*)");
        default = [];
        description = "Which keywords refer to this flag";
      };
      description = mkOption {
        type = str;
        default = "";
        description = "Description of the flag value";
      };
      validator = mkOption {
        type = str;
        default = "any";
        description = "Command to run passing the input to validate the flag value";
      };
      variable = mkOption {
        type = strMatching "[A-Z][A-Z_]*";
        description = "Variable to store the result";
      };
      required = mkOption {
        type = bool;
        description = "Is the value required?";
        default = false;
      };
    };
  });
  command = {
    name = mkOption {
      type = strMatching "[a-z_][a-z0-9_\\-]*";
      default = "example";
      description = "Name of the command shown on --help";
    };
    description = mkOption {
      type = str;
      default = "Example cli script generated with nix";
      description = "Command description";
    };
    flags = mkOption {
      type = listOf flag;
      default = [];
      description = "Command flags";
    };
    subcommands = mkOption {
      type = attrsOf (submodule ({name, ...}: {
        options = command;
        config = { inherit name; }; 
      }));
      default = {};
      description = "Subcommands has all the attributes of commands, even subcommands...";
    };
    allowExtraArguments = mkOption {
      type = bool;
      default = false;
      description = "Allow the command to receive unmatched arguments";
    };
    action = mkOption {
      type = attrsOf str;
      default = {
        bash = "exit 0";
        c = "exit(0);";
      };
      description = "Attr of the action code itself of the command or subcommand for each language that you want to support";
    };
  };
in {
  options = command;
}
