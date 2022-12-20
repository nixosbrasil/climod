{ pkgs, lib, config, options, ... }:
let
  nmd = import (pkgs.fetchgit {
    url = "https://gitlab.com/rycee/nmd";
    sha256 = "sha256-Z1hc7M9X6L+H83o9vOprijpzhTfOBjd0KmUTnpHAVjA=";
  }) { inherit pkgs; };
  doc = pkgs.nixosOptionsDoc {
    inherit options;
  };
in {
  # target.docs.options = nmd.buildModulesDocs {
  #   moduleRootPaths = [ ../../.. ];
  #   modules = [ 
  #     ../..
  #     ({ # scrub pkgs
  #       imports = [{
  #         _module.args = {
  #           pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
  #           pkgs_i686 = lib.mkForce { };
  #         };
  #         _module.check = false;
  #       }];
  #     })
  #   ];
  #   mkModuleUrl = path: "https://github.com/nixosbrasil/climod/tree/master/${path}";
  #   channelName = "climod";
  #   docBook = {
  #     id = "climod-options";
  #     optionIdPrefix = "climod-opt";
  #   };
  # };
}
