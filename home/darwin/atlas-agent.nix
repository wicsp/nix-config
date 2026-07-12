# Atlas Agent — home-manager module for macsp
#
# Creates the Atlas agent token file and exposes environment variables
# for pi/Lumio sessions. Token is provisioned via agenix.
#
# RFC 0001: Connected Lumio Agent
{ config, lib, ... }:
let
  atlasDir = "${config.home.homeDirectory}/.config/atlas";
in
{
  # Create the atlas config directory and token file.
  # The token is decrypted by agenix at system level and placed in /etc/agenix/.
  # We reference /etc/agenix/ directly because config.age is a darwin-level
  # option not available in home-manager context.
  home.file."atlas-agent-token" = {
    target = "${atlasDir}/atlas-agent-token";
    source = "/etc/agenix/atlas-agent-token";
  };

  home.file."atlas-dir-readme" = {
    target = "${atlasDir}/README";
    text = ''
      Atlas agent token — managed by nix-config (agenix). Do not edit manually.
      To rotate: update the secret in nix-secrets, rekey, and rebuild.
    '';
  };

  # Expose Atlas configuration to interactive pi/Lumio sessions.
  home.sessionVariables = {
    ATLAS_URL = "http://100.100.10.3:8000";
    ATLAS_AGENT_TOKEN_FILE = "${atlasDir}/atlas-agent-token";
    ATLAS_NODE_ID = "macsp";
  };
}
