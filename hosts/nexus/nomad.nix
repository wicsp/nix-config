{
  services.nomad.settings = {
    bind_addr = "0.0.0.0";
    advertise = {
      # Defaults to the first private IP address.
      http = "nexus:4646";
      rpc = "nexus:4647";
      serf = "nexus:4648"; # non-default ports may be specified
    };
    servers = [ "goudan.gate-monster.ts.net:4647" ];
    client = {
      enabled = true;
    };

  };
}
