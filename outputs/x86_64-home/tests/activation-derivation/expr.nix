{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.homeConfigurations) (
  name:
  let
    drvPath = outputs.homeConfigurations.${name}.activationPackage.drvPath;
  in
  builtins.isString drvPath && lib.hasSuffix ".drv" drvPath
)
