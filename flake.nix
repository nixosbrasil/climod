{
  description = "Dev Environment";

  inputs.nixpkgs.url  = "github:nixos/nixpkgs/22.05";
  inputs.dsf.url      = "github:cruel-intentions/devshell-files";
  inputs.gha.url      = "github:cruel-intentions/gh-actions";
  inputs.dsf.inputs.nixpkgs.follows = "nixpkgs";
  inputs.gha.inputs.nixpkgs.follows = "nixpkgs";
  inputs.gha.inputs.dfs.follows     = "dfs";

  outputs = inputs: inputs.dsf.lib.shell inputs [
    "${inputs.gha}/gh-actions.nix"
    ./docs/book.nix
  ];
}
