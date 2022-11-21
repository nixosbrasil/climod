{ pkgs, ...}:
let
  url = "https://github.com/nixosbrasil/climod";
  src =  builtins.fetchGit {
    inherit url;
    rev = "b756461071cbbb105e7913e743795c09337e45b6";
    ref = "master";
  };
  pkg = pkgs.writeText "climodmod.nix"
    (builtins.replaceStrings
      ["        options = command;"]
      [''options.name = mkOption { type = str; default = "..."; description = "This is a recursive from command"; };'']
      (builtins.readFile "${src}/modules/common.nix"));
in
{
  files.docs."/docs/src/climod.md".modules = [
    "${pkg}"
    "${src}/modules/bash/default.nix"
  ];
  files.mdbook.summary = ''
    ---
    - [Climod](./climod.md)
  '';
  about.sources = "- [Climod](${url})";
}
