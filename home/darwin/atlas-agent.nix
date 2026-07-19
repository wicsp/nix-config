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
  atlasObsidianVault = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vortex";
  bilibiliAsrRoot = "${config.home.homeDirectory}/Library/Caches/Lumio/asr/whisper";
  bilibiliAsrModel = "${bilibiliAsrRoot}/ggml-small.bin";
  lumioDir = "${config.home.homeDirectory}/Projects/lumio";
  lumioLogDir = "${config.home.homeDirectory}/Library/Logs/Lumio";
  profileBin = "${config.home.profileDirectory}/bin";
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

  # Model weights are rebuildable cache data, not Git/Nix state. The package
  # provides whisper-cpp-download-ggml-model for the explicit one-time fetch.
  home.activation.bilibiliAsrRoot = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg bilibiliAsrRoot}
    $DRY_RUN_CMD chmod 700 ${lib.escapeShellArg bilibiliAsrRoot}
  '';

  home.activation.lumioLogDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg lumioLogDir}
    $DRY_RUN_CMD chmod 700 ${lib.escapeShellArg lumioLogDir}
  '';

  # Expose Atlas configuration to interactive pi/Lumio sessions.
  home.sessionVariables = {
    ATLAS_URL = "http://100.100.10.3:8000";
    ATLAS_AGENT_TOKEN_FILE = "${atlasDir}/atlas-agent-token";
    ATLAS_ARTIFACT_ROOT = atlasArtifactRoot;
    # RFC 0003: Lumio writes only rebuildable Resource Cards and explicit empty
    # comment templates here. Human Knowledge prose remains user-owned.
    ATLAS_OBSIDIAN_VAULT = atlasObsidianVault;
    ATLAS_NODE_ID = "macsp";
    BILIBILI_ASR_MODEL = bilibiliAsrModel;
    BILIBILI_ASR_MAX_DURATION_SECONDS = "7200";
  };

  # RFC 0006: one bounded controller run at 02:00 (or the next wake after a
  # missed calendar event). The controller starts and stops its own headless
  # Pi RPC child, so no permanent second Lumio worker is needed.
  launchd.agents.lumio-bilibili-atlas-queue = {
    enable = true;
    config = {
      ProgramArguments = [
        "${profileBin}/uv"
        "run"
        "--project"
        "${lumioDir}/skills/bilibili-video-summary"
        "python"
        "${lumioDir}/skills/bilibili-video-summary/scripts/nightly_atlas_queue.py"
      ];
      WorkingDirectory = lumioDir;
      ProcessType = "Background";
      StartCalendarInterval = {
        Hour = 2;
        Minute = 0;
      };
      EnvironmentVariables = {
        HOME = config.home.homeDirectory;
        PATH = "${profileBin}:${config.home.homeDirectory}/.npm/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        ATLAS_URL = "http://100.100.10.3:8000";
        ATLAS_AGENT_TOKEN_FILE = "${atlasDir}/atlas-agent-token";
        ATLAS_ARTIFACT_ROOT = atlasArtifactRoot;
        ATLAS_OBSIDIAN_VAULT = atlasObsidianVault;
        ATLAS_NODE_ID = "macsp";
        BILIBILI_ASR_MODEL = bilibiliAsrModel;
        BILIBILI_ASR_MAX_DURATION_SECONDS = "7200";
        LUMIO_PI_BIN = "${config.home.homeDirectory}/.npm/bin/pi";
        LUMIO_BILIBILI_BROWSER = "dia";
        LUMIO_BILIBILI_NIGHTLY_SECONDS = "21600";
      };
      StandardOutPath = "${lumioLogDir}/bilibili-atlas-queue.log";
      StandardErrorPath = "${lumioLogDir}/bilibili-atlas-queue.error.log";
    };
  };
}
