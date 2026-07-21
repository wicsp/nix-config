{
  lib,
  outputs,
}:
lib.genAttrs (builtins.attrNames outputs.homeConfigurations) (_: true)
