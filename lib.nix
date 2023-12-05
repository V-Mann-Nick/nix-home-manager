{pkgs, ...}: {
  _module.args = {
    helpers = {
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
    };
  };
}
