{ lib
, pkgs
, fetchgit
, ...}:
let
  nmd = import (fetchgit {
    url = "https://gitlab.com/rycee/nmd";
    sha256 = "sha256-Z1hc7M9X6L+H83o9vOprijpzhTfOBjd0KmUTnpHAVjA=";
  }) { inherit pkgs; };
  modulesDocs = nmd.buildModulesDocs {
      moduleRootPaths = [ ../. ];
      modules = [
        ({ # scrub pkgs
          imports = [{
            _module.args = {
              pkgs = lib.mkForce (nmd.scrubDerivations "pkgs" pkgs);
              pkgs_i686 = lib.mkForce { };
              expandRecursiveness = false;
            };
            _module.check = false;
          }];
        })
        ../modules
      ];
      mkModuleUrl = path: "https://github.com/nixosbrasil/climod/tree/master/${path}";
      channelName = "climod";
      docBook = {
        id = "climod-options";
        optionIdPrefix = "climod-opt";
      };
    };
    book = nmd.buildDocBookDocs {
      pathName = "climod";
      projectName = "Climod";
      modulesDocs = [ modulesDocs ];
      documentsDirectory = ./.;
      documentType = "book";
      chunkToc = "";
      # snippet stole from home-manager
      # chunkToc = ''
      # <toc>
      #   <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-climod-manual"><?dbhtml filename="index.html"?>
      #     <d:tocentry linkend="ch-options"><?dbhtml filename="climod-options.html"?></d:tocentry>
      #     <d:tocentry linkend="ch-release-notes"><?dbhtml filename="release-notes.html"?></d:tocentry>
      #   </d:tocentry>
      # </toc>
      # '';
    };
in modulesDocs
