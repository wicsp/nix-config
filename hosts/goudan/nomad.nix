{
  services.nomad.settings = {
    bind_addr = "0.0.0.0";
    advertise = {
      # Defaults to the first private IP address.
      http = "goudan:4646";
      rpc = "goudan:4647";
      serf = "goudan:4648"; # non-default ports may be specified
    };

    server = {
      enabled = true;
      bootstrap_expect = 1;
    };
    client = {
      enabled = true;
    };

  };
}
