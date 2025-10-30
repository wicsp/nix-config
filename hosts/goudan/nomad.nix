{
  services.nomad.settings = {
    bind_addr = "0.0.0.0";
    advertise = {
      # Defaults to the first private IP address.
      http = "100.100.1.3:4646";
      rpc = "100.100.1.3:4647";
      serf = "100.100.1.3:4648"; # non-default ports may be specified
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
