{ pkgs, ...}:
let
  author    = "nixosbrasil";
  edit-path = "${org-url}/${project}/edit/master/docs/{path}";
  org-url   = "https://github.com/${author}";
  project   = "climod";

  # Workaroud to fix infinity recursion
  fake-mod  = pkgs.writeText "climodmod.nix"
    (builtins.replaceStrings
      ["        options = command;"]
      [''options.name = mkOption { type = str; default = "..."; description = "This is a recursive from command"; };'']
      (builtins.readFile ../modules/common.nix));
in
{
  files.mdbook.authors      = ["NixOS Brasil <${org-url}>"];
  files.mdbook.enable       = true;
  files.mdbook.gh-author    = author;
  files.mdbook.gh-project   = project;
  files.mdbook.language     = "en";
  files.mdbook.multilingual = false;
  files.mdbook.summary      = builtins.readFile ./summary.md;
  files.mdbook.title        = "Modular Generated Command Line Interfaces";
  files.mdbook.output.html.fold.enable = true;
  files.mdbook.output.html.edit-url-template   = edit-path;
  files.mdbook.output.html.git-repository-icon = "fa-github";
  files.mdbook.output.html.git-repository-url  = "${org-url}/${project}";
  files.mdbook.output.html.no-section-label    = true;
  files.mdbook.output.html.site-url            = "/${project}/";
  files.text."/gh-pages/src/about.md" = builtins.readFile ../README.md;
  files.docs."/gh-pages/src/options.md".modules = [
    "${fake-mod}"
    ../modules/bash/default.nix
  ];
  gh-actions.gh-pages.build  = "publish-as-gh-pages";
  gh-actions.gh-pages.enable = true;
}
