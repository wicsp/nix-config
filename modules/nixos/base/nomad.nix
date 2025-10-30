{
  services.nomad = {
    enable = true;
    dropPrivileges = false;
    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      client = {
        enabled = true;
      };
    };
  };
}
