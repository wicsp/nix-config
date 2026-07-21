{ config, ... }:
{
  # make `npm install -g <pkg>` happey
  #
  # mainly used to install npm packages that updates frequently
  # such as gemini-cli, claude-code, etc.
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm
    min-release-age=2
  '';

  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: 2880
  '';
}
