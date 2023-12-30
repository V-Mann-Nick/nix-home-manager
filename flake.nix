{
  description = "Home Manager configuration of nicklas";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    pre-commit-hooks,
    nur,
    nixgl,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system}.extend nixgl.overlay;
  in {
    homeConfigurations."nicklas" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
        nur.hmModules.nur
      ];
    };
    formatter.${system} = pkgs.writeScriptBin "home-manager-fmt" ''
      ${pkgs.pre-commit}/bin/pre-commit run --all-files
    '';
    checks.${system} = {
      pre-commit = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          stylua.enable = true;
          yamllint.enable = true;
        };
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit) shellHook;
    };
  };
}
