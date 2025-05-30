{lib}: {
  username = "wicsp";
  userfullname = "wicsp";
  useremail = "wicspa@gmail.com";

  # i dont have a home lab, so i dont need to configure the networking
  networking = import ./networking.nix {inherit lib;};

  # generated by `mkpasswd -m scrypt`
  initialHashedPassword = "$7$CU..../....tNrk/pG9YIlz613nExBfc/$tl32KnLcoq32d.ZkYy5ld14KLp4.8AhdBcEG8IU6Sr/";
  # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
  #
  # Since its authority is so large, we must strengthen its security:
  # 1. The corresponding private key must be:
  #    1. Generated locally on every trusted client via:
  #      ```bash
  #      # KDF: bcrypt with 256 rounds, takes 2s on Apple M2):
  #      # Passphrase: digits + letters + symbols, 12+ chars
  #      ssh-keygen -t ed25519 -a 256 -C "wicsp@xxx" -f ~/.ssh/xxx`
  #      ```
  #    2. Never leave the device and never sent over the network.
  # 2. Or just use hardware security keys like Yubikey/CanoKey.
  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIA7WpKIPJbG8fisvljzVnMi134ET+lVI0dsMZ9jHUiY wicsp@macsp"
  ];
}
