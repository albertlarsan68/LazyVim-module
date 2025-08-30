self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.lazyvim;
in
{
  options.programs.lazyvim.extras.linting.neoconf = {
    enable = mkEnableOption "the linting.neoconf extra";
  };

  config = mkIf cfg.extras.linting.neoconf.enable {
    programs.neovim = {
      plugins = (
        with pkgs.vimPlugins;
        [
          nvim-lspconfig
          neoconf-nvim
        ]
      );
    };
  };
}
