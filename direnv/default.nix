{...}: {
  enable = true;
  enableZshIntegration = true;
  nix-direnv.enable = true;
  stdlib = builtins.readFile ./direnvrc;
}
