{lib}: rec {
  # i dont have a home lab, so i dont need to configure the networking
  # mainGateway = "192.168.5.1"; # main router
  # mainGateway6 = "fe80::5"; # main router's link-local address
  # # use suzi as the default gateway
  # # it's a subrouter with a transparent proxy
  # proxyGateway = "192.168.5.178";
  # proxyGateway6 = "fe80::8";
  # nameservers = [
  #   # IPv4
  #   "119.29.29.29" # DNSPod
  #   "223.5.5.5" # AliDNS
  #   # IPv6
  #   "2400:3200::1" # Alidns
  #   "2606:4700:4700::1111" # Cloudflare
  # ];
  # prefixLength = 24;

  hostsAddr = {
    mio_web = {
      # Aliyun Server - 用于 SSH 连接的公网 IP
      iface = "ens5"; # 实际网卡接口
      ipv4 = "120.76.156.100"; # 公网 IP，用于 SSH 连接
    };
    mio = {
      # Aliyun Server - 用于 SSH 连接的公网 IP
      iface = "tailscale0"; # tailscale 网卡接口
      ipv4 = "100.87.168.29"; #  tailscale 分配的虚拟 IP
    };
    goudan_lab = {
      # Desktop PC - NixOS Desktop System
      iface = "enp2s0";
      ipv4 = "192.168.124.58";
    };
    goudan = {
      # Desktop PC - NixOS Desktop System
      iface = "tailscale0";
      ipv4 = "100.91.203.113"; #  tailscale 分配的虚拟 IP
    };
    amax_lab = {
      # Laptop - NixOS Laptop System
      iface = "eno1";
      ipv4 = "172.25.77.228";
    };
    amax = {
      # Laptop - NixOS Laptop System
      iface = "tailscale0";
      ipv4 = "100.74.193.128"; #  tailscale 分配的虚拟 IP
    };
  };

  # i dont need to configure the hosts interface for now, because i am using dhcp or tailscale
  # hostsInterface =
  #   lib.attrsets.mapAttrs
  #   (
  #     key: val: {
  #       interfaces."${val.iface}" = {
  #         useDHCP = false;
  #         ipv4.addresses = [
  #           {
  #             inherit prefixLength;
  #             address = val.ipv4;
  #           }
  #         ];
  #       };
  #     }
  #   )
  #   hostsAddr;

  ssh = {
    # define the host alias for remote builders
    # this config will be written to /etc/ssh/ssh_config
    # ''
    #   Host ruby
    #     HostName 192.168.5.102
    #     Port 22
    #
    #   Host kana
    #     HostName 192.168.5.103
    #     Port 22
    #   ...
    # '';
    extraConfig = ( # TODO i dont know
      lib.attrsets.foldlAttrs (
        acc: host: val:
          acc
          + ''
            Host ${host}
              HostName ${val.ipv4}
              Port 22
          ''
      ) ""
      hostsAddr
    );

    # define the host key for remote builders so that nix can verify all the remote builders
    # this config will be written to /etc/ssh/ssh_known_hosts
    knownHosts =
      # todo
      # Update only the values of the given attribute set.
      #
      #   mapAttrs
      #   (name: value: ("bar-" + value))
      #   { x = "a"; y = "b"; }
      #     => { x = "bar-a"; y = "bar-b"; }
      lib.attrsets.mapAttrs
      (host: value: {
        hostNames = [host hostsAddr.${host}.ipv4];
        publicKey = value.publicKey;
      })
      {
        goudan.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwm5K8g85ifo76RwvBDSZmuECK0I0hec3w/WMbSZzxU root@goudan";
        # ruby.publicKey = "";
        # kana.publicKey = "";

        # ==================================== Other SSH Service's Public Key =======================================

        # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
        "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
  };
}
