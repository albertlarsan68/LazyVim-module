self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.lazyvim;
in
{
  options.programs.lazyvim.extras.lang.haskell = {
    enable = mkEnableOption "the lang.haskell extra";
  };

  config = mkIf cfg.extras.lang.haskell.enable {
    programs.neovim = {
      extraPackages = with pkgs; [
        haskell-language-server
        (pkgs.haskell.lib.justStaticExecutables haskellPackages.haskell-debug-adapter)
      ];

      plugins = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins:
          attrValues {
            inherit (plugins)
              haskell
              ;
          }
        ))
        pkgs.vimPlugins.haskell-tools-nvim
        pkgs.vimPlugins.neotest-haskell
        pkgs.vimPlugins.haskell-snippets-nvim
        pkgs.vimPlugins.luasnip
        pkgs.vimPlugins.telescope_hoogle
        pkgs.vimPlugins.nvim-lspconfig
      ];
    };
  };
}
