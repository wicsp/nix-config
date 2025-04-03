{
  config,
  pkgs,
  ...
}: {
  security.sudo.extraRules = [
    {
      users = ["wicsp"];
      commands = [
        {
          command = "ALL";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];
}
