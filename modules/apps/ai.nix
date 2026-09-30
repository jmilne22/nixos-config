{ config, pkgs, inputs, ... }:
{
  # numtide/llm-agents.nix updates these daily; nixpkgs lags by days to weeks,
  # which has meant a claude-code too old to serve the current model. The
  # overlay puts everything under pkgs.llm-agents, built against our nixpkgs.
  # chatgpt is OpenAI's desktop app, which is where Codex desktop now lives.
  nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

  # codex builds from Rust source; their cache avoids compiling it locally.
  # Only takes effect after the first rebuild that includes it.
  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  environment.systemPackages = with pkgs; [
    llm-agents.claude-desktop
    llm-agents.claude-code
    llm-agents.chatgpt
    llm-agents.codex
    mcp-nixos
  ];
}
