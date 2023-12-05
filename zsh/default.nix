{config, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    history.extended = true;
    dotDir = ".config/zsh";
    initExtra = ''
      fpath+=(/usr/share/zsh)
    '';
    prezto = {
      enable = true;
      pmodules = [
        # "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        "environment"
        "terminal"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "jeffreytse/zsh-vi-mode";
        }
      ];
      zplugHome = "${config.xdg.configHome}/zplug";
    };
  };
}
