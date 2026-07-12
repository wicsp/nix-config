# Atlas Agent — home-manager module for macsp
#
# Creates the Atlas agent token file and exposes environment variables
# for pi/Lumio sessions. Token is provisioned via agenix.
#
# RFC 0001: Connected Lumio Agent
{ config, lib, ... }:
let
  atlasDir = "${config.home.homeDirectory}/.config/atlas";
  atlasArtifactRoot = "${config.xdg.dataHome}/atlas/artifacts";
in
{
  # Link the agenix-decrypted token into ~/.config/atlas/.
  # agenix decrypts at activation time, so we use mkOutOfStoreSymlink
  # (resolved at runtime) rather than home.file.source (resolved at build time).
  xdg.configFile."atlas/atlas-agent-token".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/agenix/atlas-agent-token";

  xdg.configFile."atlas/README".text = ''
    Atlas agent token — managed by nix-config (agenix). Do not edit manually.
    To rotate: update the secret in nix-secrets, rekey, and rebuild.
  '';

  # Artifact bytes live outside Atlas SQLite and remain private to the user.
  home.activation.atlasArtifactRoot = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg atlasArtifactRoot}
    $DRY_RUN_CMD chmod 700 ${lib.escapeShellArg atlasArtifactRoot}
  '';

  # Expose Atlas configuration to interactive pi/Lumio sessions.
  home.sessionVariables = {
    ATLAS_URL = "http://100.100.10.3:8000";
    ATLAS_AGENT_TOKEN_FILE = "${atlasDir}/atlas-agent-token";
    ATLAS_ARTIFACT_ROOT = atlasArtifactRoot;
    ATLAS_NODE_ID = "macsp";
  };
}
