{
  config,
  lib,
  ...
}: let
  favoriteDirs = rec {
    home = {
      aliases = ["home"];
      path = "${config.home.homeDirectory}/.config/home-manager";
    };
    code = {
      aliases = ["co"];
      path = "${config.home.homeDirectory}/Code";
    };
    huffman = {
      aliases = ["hu"];
      path = "${code.path}/personal/rust/huffman";
    };
    keycloakAdminAio = {
      aliases = ["ka"];
      path = "${code.path}/open-source/keycloak-admin-aio";
    };
    pytestDependsOn = {
      aliases = ["de"];
      path = "${code.path}/open-source/pytest-depends-on";
    };
    nix = {
      aliases = ["ni"];
      path = "${code.path}/personal/rust/nix";
    };
    portfolio = {
      aliases = ["por"];
      path = "${code.path}/personal/webdev/portfolio";
    };
    jsonParser = {
      aliases = ["jp"];
      path = "${code.path}/personal/rust/json-parser";
    };
  };
  extensionDirs =
    if lib.pathExists ./extension-dirs.nix
    then (import ./extension-dirs.nix) favoriteDirs
    else {};
  allDirs = favoriteDirs // extensionDirs;
  aliases = let
    directoryEntryToAliasEntryList = name: {
      aliases,
      path,
    }: (
      map (alias: {
        name = alias;
        value = path;
      })
      aliases
    );
    aliasEntryLists = lib.mapAttrsToList directoryEntryToAliasEntryList allDirs;
    aliasEntries = builtins.concatLists aliasEntryLists;
  in
    builtins.listToAttrs aliasEntries;
  aliasesCdls = let
    cdls = dir: "cd ${dir} && ls";
  in
    lib.mapAttrs (_: dir: cdls dir) config._module.args.aliases;
in {
  _module.args = {
    directories = allDirs;
    inherit aliases;
  };

  home.shellAliases = aliasesCdls;
}
