{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.hysteria
  ];
}
