{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.nixosConfigurations) (
  name:
  let
    drvPath = outputs.nixosConfigurations.${name}.config.system.build.toplevel.drvPath;
  in
  builtins.isString drvPath && lib.hasSuffix ".drv" drvPath
)
