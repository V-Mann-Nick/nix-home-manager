{pkgs, ...}: {
  _module.args = {
    helpers = rec {
      templateFile = name: template: data:
        with pkgs;
          stdenv.mkDerivation {
            name = "${name}";
            nativeBuildInpts = [mustache-go];
            passAsFile = ["jsonData"];
            jsonData = builtins.toJSON data;
            phases = ["buildPhase" "installPhase"];
            buildPhase = ''
              ${mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
            '';
            installPhase = ''
              mkdir -p $out
              cp rendered_file $out/${name}
            '';
          };
      templateSourceVimScript = name: template: data: let
        fileName = "${name}.vim";
      in ''
        source ${templateFile fileName template data}/${fileName}
      '';
      templateSourceLua = name: template: data: let
        fileName = "${name}.lua";
      in ''
        lua << EOF
        local current_path = package.path
        package.path = current_path .. ";${templateFile fileName template data}/?.lua"
        require("${name}")
        package.path = current_path
        EOF
      '';
    };
  };
}
