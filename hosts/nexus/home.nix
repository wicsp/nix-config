{
  config,
  ...
}:
{
  programs.ssh.settings."github.com".identityFile = "${config.home.homeDirectory}/.ssh/nexus";
}
