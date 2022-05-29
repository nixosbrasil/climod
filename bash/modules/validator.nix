{ lib
, ...
}:
let
  inherit (lib) types mkOption;
  inherit (types) str attrsOf submodule;
in
{
  options = {
    validators = mkOption {
      type = attrsOf str;
    };
  };
  config = {
    validators = {
      any = "true";
      fso = ''test -e "$1"'';
      file = ''test -f "$1"'';
      dir = ''test -d "$1"'';
      readable = ''test -r "$1"'';
      writable = ''test -w "$1"'';
      executable = ''test -x "$1"'';
      pipe = ''test -p "$1"'';
      socket = ''test -S "$1"'';
      not-empty = ''test -s "$1"'';
      int = ''echo $1 | grep -Eq "^-?[0-9]*$"'';
      float = ''echo $1 | grep -Eq "^-?[0-9]*.?[0-9]*$"'';
    };
  };
}
