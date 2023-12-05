{
  pkgs,
  neovim,
  ...
}: {
  programs.neovim.coc = {
    enable = true;
    package = neovim.plugin {
      repo = "V-Mann-Nick/coc.nvim";
      ref = "release";
      rev = "e863929826ad667db95e8ec93ddcf2d33bdba77e";
    };
    settings = {
      "workspace.bottomUpFiletypes" = ["*"];
      "workspace.workspaceFolderCheckCwd" = false;
      "tsserver.useLocalTsdk" = true;
      "typescript.format.enable" = false;
      "javascript.format.enable" = false;
      "python.formatting.provider" = "black";
      "python.linting.flake8Enabled" = true;
      "pyright.organizeimports.provider" = "isort";
      "suggest.noselect" = true;
      "eslint.autoFixOnSave" = false;
      "eslint.workingDirectories" = [{"mode" = "auto";}];
      "eslint.packageManager" = "pnpm";
      "yaml.customTags" = ["!reference sequence"];
      "rust-analyzer.server.path" = "rust-analyzer";
      "dialog.rounded" = true;
      "languageserver" = {
        "nix" = {
          "command" = "${pkgs.nil}/bin/nil";
          "filetypes" = ["nix"];
          "rootPatterns" = ["flake.nix"];
          "settings" = {
            "nil" = {
              "formatting" = {"command" = ["${pkgs.alejandra}/bin/alejandra"];};
            };
          };
        };
        # nixd = {
        #   command = "${pkgs.nixd}/bin/nixd";
        #   rootPatterns = [".nixd.json"];
        #   filetypes = ["nix"];
        # };
      };
    };
    pluginConfig = neovim.templateSourceVimScript "coc-plugin-config.vim" ./coc.vim {leader = neovim.leader;};
  };
}
