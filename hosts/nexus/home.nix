{
  config,
  ...
}:
{
  programs.ssh.matchBlocks."github.com".identityFile = "${config.home.homeDirectory}/.ssh/nexus";
}
