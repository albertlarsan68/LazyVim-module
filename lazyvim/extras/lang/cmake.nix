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
  options.programs.lazyvim.extras.lang.cmake = {
    enable = mkEnableOption "the lang.cmake extra";
  };

  config = mkIf cfg.extras.lang.cmake.enable {
    programs.neovim = {
      extraPackages = with pkgs; [
        cmake-lint
        cmake-format
        neocmakelsp
      ];

      plugins = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins: builtins.attrValues { inherit (plugins) cmake; }
        ))
      ]
      ++ (with pkgs.vimPlugins; [
        nvim-lspconfig
        cmake-tools-nvim
      ]);
    };
  };
}
