{lib, config, ...}:
let
  inherit (lib) mkOption types optionalString mkIf;
  inherit (builtins) concatStringsSep length attrValues mapAttrs filter;
in {
  imports = [
    ./validator.nix
    ./derivation.nix
  ];
  options = {
    target.bash = {
      prelude = mkOption {
        type = types.lines;
        description = "Stuff that must be added before the argument parser";
        default = "";
      };
      shebang = mkOption {
        type = types.str;
        description = "Script shebang";
        default = "#!/usr/bin/env bash";
      };
      code = mkOption {
        type = types.lines;
        description = "Code output";
      };
      validators = mkOption {
        type = types.attrsOf types.str;
        description = "Parameter validators";
      };
    };
  };
  config = {
    target.bash.code = let
      buildHelp = cfg: let
          subcommandTree = cfg._subcommand;
          subcommandTree' = concatStringsSep " " subcommandTree;

          firstLine = "$(bold '${subcommandTree'}') ${cfg.description}";
          firstLine' = "echo \"${firstLine}\"";
          subcommands = mapAttrs (k: v: v.description) cfg.subcommands;
          subcommands' = mapAttrs (k: v: ''
            printf "\t"
            printf "$(bold '${k}'): "
            echo '${v}'
          '') subcommands;
          subcommands'' = attrValues subcommands';
          subcommands''' = concatStringsSep "\n" subcommands'';

          hasSubcommands = length (attrValues subcommands) > 0;
          
          flag2txt = flag: let
            keywordLine = flag.keywords;
            keywordLine' = concatStringsSep ", " keywordLine;
          in ''
            printf "\t"
            echo "$(bold '${keywordLine'}, ${flag.variable}') (${flag.validator}): ${flag.description}"
          '';

          flags = cfg.flags;
          flags' = [''
            printf "\t"
            echo "$(bold '-h, --help'): Show this help message"
          ''] ++ (map flag2txt flags);
          flags'' = concatStringsSep "\n" flags';
        in ''
          ${firstLine'}
          ${optionalString hasSubcommands ''printf "\nSubcommands\n"''}
          ${subcommands'''}
          printf "\nFlags\n"
          ${flags''}
          exit 0
        '';
      buildCommandTree = cfg: let
        help = buildHelp cfg;

        mkSubcommandHandler = k: v: let
          flags = cfg.flags ++ v.flags;
          _subcommand = cfg._subcommand ++ [ v.name ];
          subcommandArgs = v // { inherit flags _subcommand; };
          handler = buildCommandTree subcommandArgs;
          handler' = ''
            ${k})
              shift
              ${handler}
              exit 0
            ;;
          '';
          in handler';

        mkFlagHandler = flag:
        let
          caseExpr = concatStringsSep " | " flag.keywords;
          varAttrExpr = ''${flag.variable}="$2"'';
          validateExprError = ''echo "flag '$flagkey' (${flag.variable}) doesn't pass the validation as a ${flag.validator}" '';

          isBool = flag.validator == "bool";
          validateExpr = optionalString (!isBool) ''validate_${flag.validator} "$2" || ${validateExprError}'';
        in ''
          ${caseExpr} )
            ${optionalString isBool "export ${flag.variable}=1"}
            ${optionalString isBool "shift; continue"}

            if [ $# -eq 1 ]; then
              error "the flag '$flagkey' expects a value of type ${flag.validator} but found end of parameters"
            fi
            ${validateExpr}
            ${varAttrExpr}
            shift; shift
            break
          ;;
        '';
        subcommands = cfg.subcommands;
        subcommands' = mapAttrs mkSubcommandHandler subcommands;
        subcommands'' = attrValues subcommands';
        subcommands''' = concatStringsSep "\n" subcommands'';
        flags = cfg.flags;
        flags' = map mkFlagHandler flags;
        flags'' = concatStringsSep "\n" flags';

        requiredFlags = filter (f: f.required) flags;
        requiredFlags' = map (f: f.variable) requiredFlags;
        requiredFlags'' = map (var: concatStringsSep "" [
          ''echo "$'' var ''" > /dev/null # will fail if the variable is not defined''
        ]) requiredFlags';
        requiredFlags''' = concatStringsSep "\n" requiredFlags'';
      in ''
        if [ $# -gt 0 ]; then
          case "$1" in
            ${subcommands'''}
          esac
        fi
        ARGS=()
        while [ ! $# -eq 0 ]; do
          local flagkey="$1"

          case "$flagkey" in
              -h | --help)
                ${help}
              ;;
                ${flags''}
              *)
                  ${if cfg.allowExtraArguments then ''
                    ARGS+=("$1")
                    shift
                  '' else ''
                    error "invalid keyword argument near '$flagkey'"
                  ''}
              ;;
          esac
        done
        ${requiredFlags'''}
        function payload {
          ${cfg.action.bash}
        }
        payload "${"$"}{ARGS[@]}"
        exit 0
        '';

      mkValidatorHandler = k: v: ''
        function validate_${k} {
          ${v}
        }
      '';
      validators = config.target.bash.validators;
      validators' = mapAttrs mkValidatorHandler validators;
      validators'' = attrValues validators';
      validators''' = concatStringsSep "\n" validators'';
    in ''
        ${config.target.bash.shebang}
        set -eu
        function error {
          echo "$(bold "error"): $@" >&2
          exit 1
        }
        function bold {
          if which tput >/dev/null 2>/dev/null; then
            printf "$(tput bold)$*$(tput sgr0)"
          else
            printf "$*"
          fi
        }
        ${config.target.bash.prelude}

        ${validators'''}

        function _main() {
          ${buildCommandTree (config // {
            _subcommand = [ config.name ];
          })}
        }
        _main "$@"
    '';
  };
}
