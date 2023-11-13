{ config, ... }:
{
  enable = true;
  enableAutosuggestions = false;
  syntaxHighlighting.enable = false;
  enableCompletion = false;
  history.extended = true;
  dotDir = ".config/zsh";
  initExtra = ''
    fpath+=(/usr/share/zsh)
  '';
  initExtraFirst = ''
    # eval "$(rbenv init - zsh)"
    eval "$(direnv hook zsh)"

    # export PYENV_ROOT="$HOME/.pyenv"
    # command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    # eval "$(pyenv init -)"
  '';
  prezto = {
    enable = true;
    pmodules = [
      "syntax-highlighting"
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
}
