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
  options.programs.lazyvim.extras.lang.clangd = {
    enable = mkEnableOption "the lang.clangd extra";
  };

  config = mkIf cfg.extras.lang.clangd.enable {
    programs.neovim = {
      plugins = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins: builtins.attrValues { inherit (plugins) cpp; }
        ))
      ]
      ++ (with pkgs.vimPlugins; [
        clangd_extensions-nvim
      ]);
    };
  };
}
