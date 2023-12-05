{...}: {
  home.shellAliases = {
    g = "git";
  };

  programs.git = {
    enable = true;
    userName = "Nicklas Sedlock";
    userEmail = "nicklas.sedlock@posteo.net";
    diff-so-fancy.enable = true;
    ignores = [".vscode"];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
