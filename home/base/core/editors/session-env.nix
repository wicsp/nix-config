_: {
  # Daily editing may use the user's configuration, while privileged edits
  # stay on a clean Neovim instance across the sudo trust boundary.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim --clean";
  };
}
