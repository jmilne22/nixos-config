{ config, pkgs, inputs, ... }:
{
  # numtide/llm-agents.nix updates these daily; nixpkgs lags by days to weeks,
  # which has meant a claude-code too old to serve the current model. The
  # overlay puts everything under pkgs.llm-agents, built against our nixpkgs.
  # chatgpt is OpenAI's desktop app, which is where Codex desktop now lives.
  nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

  environment.systemPackages = with pkgs; [
    llm-agents.claude-desktop
    llm-agents.claude-code
    llm-agents.chatgpt
    llm-agents.codex
    mcp-nixos
  ];
}
