{pkgs, ...}: {
  imports = [
    ./theme.nix
    ./extensions.nix
    ./dconf.nix
    ./geary.nix
  ];
  home.packages = with pkgs; [eyedropper];
}
