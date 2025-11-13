{
  daeuniverse,
  pkgs,
  ...
}:
{
  imports = [
    daeuniverse.nixosModules.dae
    daeuniverse.nixosModules.daed
  ];

  services.dae = {
    enable = true;

    openFirewall = {
      enable = true;
      port = 12345;
    };

    /*
      default options

      package = inputs.daeuniverse.packages.x86_64-linux.dae;
      disableTxChecksumIpGeneric = false;
      configFile = "/etc/dae/config.dae";
      assets = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
    */

    # alternative of `assets`, a dir contains geo database.
    # assetsPath = "/etc/dae";
  };

  # services.daed = {
  #   enable = true;

  #   openFirewall = {
  #     enable = true;
  #     port = 12345;
  #   };
  #   package = daeuniverse.packages.x86_64-linux.daed;

  #   /*
  #     default options

  #     package = inputs.daeuniverse.packages.x86_64-linux.daed;
  #     configDir = "/etc/daed";
  #     listen = "127.0.0.1:2023";
  #   */
  # };
}
