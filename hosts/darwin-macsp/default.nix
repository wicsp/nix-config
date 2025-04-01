_:
#############################################################
#
#  Fern - MacBook Pro 2022 13-inch M2 16G, mainly for business.
#
#############################################################
let
  hostname = "macsp";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
