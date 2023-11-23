{
  pkgs,
  templateSourceVimScript,
  leader,
  ...
}: {
  enable = true;
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
  pluginConfig = templateSourceVimScript "coc-plugin-config.vim" ./coc.vim {inherit leader;};
}
