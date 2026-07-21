{ config, ... }:
let
  rules = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/AGENTS.md";
in
{
  # One source of truth for coding-agent behavior across supported clients.
  home.file = {
    ".codex/AGENTS.md".source = rules;
    ".claude/CLAUDE.md".source = rules;
    ".agents/AGENTS.md".source = rules;
    ".config/opencode/AGENTS.md".source = rules;
  };
}
