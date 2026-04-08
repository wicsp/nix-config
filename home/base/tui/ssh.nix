{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    # default config
    enableDefaultConfig = false;

    matchBlocks."*" = {
      forwardAgent = false;
      # "a private key that is used during authentication will be added to ssh-agent if it is running"
      addKeysToAgent = "yes";
      compression = true;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    }
    // (pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      # Use Secretive as SSH agent on macOS (keys stored in Secure Enclave)
      identityAgent = "/Users/wicsp/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    });

    matchBlocks = {
      "github.com" = {
        # "Using SSH over the HTTPS port for GitHub"
        # "(port 22 is banned by some proxies / firewalls)"
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        # Use forwarded agent from local machine (e.g. macbook) when available
        forwardAgent = true;
      };

      "100.100.*" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };

      "goudan" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "amax" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };
      "mio" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };
      "falcon" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };
      "hydra" = {
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };
      "nexus" = {
        user = "root";
        # "allow to securely use local SSH agent to authenticate on the remote machine."
        # "It has the same effect as adding cli option `ssh -A user@host`"
        forwardAgent = true;
        # "zenith holds my homelab~"
        identityFile = "~/.ssh/zenith";
        identitiesOnly = true;
      };

    };
  };
}
