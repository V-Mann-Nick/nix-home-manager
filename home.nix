args @ {
  lib,
  pkgs,
  ...
}:
with lib; let
  # https://stackoverflow.com/a/54505212/15782961
  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
      );
  in
    f [] attrList;

  username = "nicklas";
  homeDirectory = "/home/${username}";

  directories = rec {
    code = {
      aliases = ["co"];
      path = "${homeDirectory}/Code";
    };
    keycloakAdminAio = {
      aliases = ["ka"];
      path = "${code.path}/open-source/keycloak-admin-aio";
    };
    nix = {
      aliases = ["ni"];
      path = "${code.path}/personal/rust/nix";
    };
    portfolio = {
      aliases = ["por"];
      path = "${code.path}/personal/webdev/portfolio";
    };
  };

  extension =
    if pathExists ./extension.nix
    then (import ./extension.nix) (args // {inherit directories;})
    else {};
  allDirectories = directories // (extension.directories or {});

  base = (import ./base.nix) (args
    // {
      inherit username homeDirectory;
      directories = allDirectories;
    });
in
  recursiveMerge [base (extension.homeManagerConfig or {})]
