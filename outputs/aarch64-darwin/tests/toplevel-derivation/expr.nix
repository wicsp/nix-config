{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.darwinConfigurations) (
  name:
  let
    drvPath = outputs.darwinConfigurations.${name}.system.drvPath;
  in
  builtins.isString drvPath && lib.hasSuffix ".drv" drvPath
)
