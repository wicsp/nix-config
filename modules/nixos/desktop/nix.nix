{ config, ... }:
{
  # Desktop users need authenticated access to GitHub-backed flake inputs.
  # Keep this out of the base module so server/bootstrap configurations do not
  # depend on a desktop-only agenix secret during evaluation.
  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-tokens.path}
  '';
}
