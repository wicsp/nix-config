{
  config,
  pkgs,
  agenix,
  mysecrets,
  myvars,
  ...
}:
{
  imports = [
    agenix.darwinModules.default
  ];

  # enable logs for debugging
  launchd.daemons."activate-agenix".serviceConfig = {
    StandardErrorPath = "/Library/Logs/org.nixos.activate-agenix.stderr.log";
    StandardOutPath = "/Library/Logs/org.nixos.activate-agenix.stdout.log";
  };

  environment.systemPackages = [
    agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  age.identityPaths = [
    # Generate manually via `sudo ssh-keygen -A`
    "/etc/ssh/ssh_host_ed25519_key" # macOS, using the host key for decryption
  ];

  age.secrets =
    let
      noaccess = {
        mode = "0000";
        owner = "root";
      };
      high_security = {
        mode = "0500";
        owner = "root";
      };
      user_readable = {
        mode = "0500";
        owner = myvars.username;
      };
    in
    {
      # ---------------------------------------------
      # no one can read/write this file, even root.
      # ---------------------------------------------

      # # .age means the decrypted file is still encrypted by age(via a passphrase)
      # "ryan4yin-gpg-subkeys.priv.age" =
      #   {
      #     file = "${mysecrets}/ryan4yin-gpg-subkeys-2024-01-27.priv.age.age";
      #   }
      #   // noaccess;

      # ---------------------------------------------
      # only root can read this file.
      # ---------------------------------------------

      # "wg-business.conf" =
      #   {
      #     file = "${mysecrets}/wg-business.conf.age";
      #   }
      #   // high_security;

      # "rclone.conf" =
      #   {
      #     file = "${mysecrets}/rclone.conf.age";
      #   }
      #   // high_security;

      "nix-access-tokens" = {
        file = "${mysecrets}/nix-access-tokens.age";
      }
      # access-token needs to be readable by the user running the `nix` command
      // user_readable;

      # ---------------------------------------------
      # user can read this file.
      # ---------------------------------------------
      "secrets_env" = {
        file = "${mysecrets}/secrets_env.age";
      }
      // user_readable;
      "ssh-key-zenith" = {
        file = "${mysecrets}/ssh-key-zenith.age";
      }
      // user_readable;

      "config.dae" = {
        file = "${mysecrets}/config.dae.age";
      }
      // user_readable;

      "atlas-agent-token" = {
        file = "${mysecrets}/atlas-agent-token.age";
      }
      // user_readable;

    };

  # place secrets in /etc/
  # NOTE: this will fail for the first time. cause it's running before "activate-agenix"
  environment.etc = {
    # # wireguard config used with `wg-quick up wg-business`
    # # Fix DNS for WireGuard on macOS: https://github.com/ryan4yin/nix-config/issues/5
    # "wireguard/wg-business.conf" = {
    #   source = config.age.secrets."wg-business.conf".path;
    # };

    # "agenix/rclone.conf" = {
    #   source = config.age.secrets."rclone.conf".path;
    # };

    "agenix/ssh-key-zenith" = {
      source = config.age.secrets."ssh-key-zenith".path;
    };

    # "agenix/ryan4yin-gpg-subkeys.priv.age" = {
    #   source = config.age.secrets."ryan4yin-gpg-subkeys.priv.age".path;
    # };

    "agenix/secrets_env" = {
      source = config.age.secrets."secrets_env".path;
    };
    "agenix/atlas-agent-token" = {
      source = config.age.secrets."atlas-agent-token".path;
    };
    "agenix/nix-access-tokens" = {
      source = config.age.secrets."nix-access-tokens".path;
    };
    "dae/config.dae" = {
      source = config.age.secrets."config.dae".path;
    };
  };

  # both the original file and the symlink should be readable and executable by the user
  # activationScripts are executed every time you run `nixos-rebuild` / `darwin-rebuild` or boot your system
  system.activationScripts.postActivation.text = ''
    if [ -d /etc/agenix ]; then
      find /etc/agenix -mindepth 1 -maxdepth 1 -exec chown ${myvars.username} {} +
    fi
    if [ -d /etc/dae ]; then
      find /etc/dae -mindepth 1 -maxdepth 1 -exec chown ${myvars.username} {} +
    fi
  '';
}
