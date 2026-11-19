{ config, pkgs, inputs, ... }:
let
  # numtide/llm-agents.nix updates these daily; nixpkgs lags by days to weeks,
  # which has meant a claude-code too old to serve the current model. Taken from
  # the flake's own packages (built against its pinned nixpkgs, see flake.nix)
  # rather than its overlay, so they come prebuilt from cache.numtide.com.
  # chatgpt is OpenAI's desktop app, which is where Codex desktop now lives.
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Only takes effect after the first rebuild that includes it.
  nix.settings = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  environment.systemPackages = with pkgs; [
    llm-agents.claude-desktop
    llm-agents.claude-code
    llm-agents.chatgpt
    antigravity-ide-fhs
    mcp-nixos
  ];
}
