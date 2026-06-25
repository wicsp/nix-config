{ catppuccin, ... }:
{
  # https://github.com/catppuccin/nix
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    # The default `enable` value for all available programs.
    enable = true;
    # Explicitly set to match `enable` and suppress upcoming migration warning
    autoEnable = true;
    # one of "latte", "frappe", "macchiato", "mocha"
    flavor = "mocha";
    # one of "blue", "flamingo", "green", "lavender", "maroon", "mauve", "peach", "pink", "red", "rosewater", "sapphire", "sky", "teal", "yellow"
    accent = "pink";

    # We already manage starship settings ourselves. Keeping the upstream
    # Catppuccin starship module enabled forces local evaluation to realize a
    # target-platform store path, which breaks cross-platform colmena evals.
    starship.enable = false;
  };
}
