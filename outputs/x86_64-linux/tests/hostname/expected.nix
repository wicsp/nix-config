{
  lib,
  outputs,
}:
let
  specialExpected = {
    "goudan-hyprland" = "goudan";
    "goudan-niri" = "goudan";
  };
  specialHostNames = builtins.attrNames specialExpected;

  otherHosts = builtins.removeAttrs outputs.nixosConfigurations specialHostNames;
  otherHostsNames = builtins.attrNames otherHosts;
  otherExpected = lib.genAttrs otherHostsNames (name: name);
in
specialExpected // otherExpected
