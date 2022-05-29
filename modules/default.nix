{config, ...}:
{
  imports = [
    ./extra.nix
    ./common.nix
    (./. + "/" + config.language)
  ];
}
