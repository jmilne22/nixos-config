# nixos-config

Personal NixOS flake configuration for multiple hosts.

## Layout

- `flake.nix` — defines a `nixosConfigurations.<hostname>` entry per machine
- `hosts/<hostname>/` — per-host config (`default.nix` + `hardware-configuration.nix`).
  Holds only what genuinely differs per machine: bootloader, hardware quirks,
  `networking.hostName`, `system.stateVersion`, and the list of modules to import.
- `modules/core.nix` — settings every machine gets; always imported
- `modules/desktops/` — pick **one** per host (`gnome.nix`, `plasma.nix`, `mangowc.nix`).
  `desktops/common/` is shared plumbing that those modules import themselves — never
  import it from a host.
- `modules/apps/` — pick any (`development.nix`, `gaming.nix`, …). Each file owns
  everything for one concern, including any services it needs: `gaming.nix` enables
  Steam as well as installing mangohud.
- `modules/users/user.nix` — shared user account definition

## Adding a new host

On a fresh NixOS install, git isn't available by default, so grab it via `nix shell` first.

1. **Get git and clone the repo**

   ```
   nix shell nixpkgs#git
   git clone <this-repo-url> ~/nixos-config
   cd ~/nixos-config
   ```

2. **Copy an existing host as a starting point** — pick whichever is closer to the new machine (`laptop` for a laptop-like device, `desktop` otherwise):

   ```
   cp -r hosts/desktop hosts/<hostname>
   ```

3. **Swap in the new machine's hardware config** (the copied one won't match new hardware). The installer already generates one at `/etc/nixos/hardware-configuration.nix` — just copy that over:

   ```
   cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/hardware-configuration.nix
   ```

   (Or run `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix` if you need to regenerate it.)

4. **Edit `hosts/<hostname>/default.nix`**:
   - Set `networking.hostName = "<hostname>";`
   - Adjust the `imports` list — swap the desktop (`modules/desktops/gnome.nix`, `plasma.nix`, `mangowc.nix`) and app sets (`modules/apps/*.nix`) to whatever the new host needs
   - Drop/add any host-specific hardware modules (e.g. the laptop's `chuwi-minibook-x` block) as needed
   - Update `system.stateVersion` if `nixos-generate-config` reported a different one

5. **Register it in `flake.nix`**, under `nixosConfigurations`:

   ```nix
   <hostname> = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       ./hosts/<hostname>
     ];
   };
   ```

6. **Build/switch**:

   ```
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Notes

- `result` / `result-*` are build symlinks and are gitignored — don't commit them. The
  pattern matches at any depth, so a stray `result` inside a subdirectory won't show up in
  `git status` but will still pin an old system closure as a GC root.
- Only one display manager can be enabled at a time. They all feed
  `services.displayManager.generic.execCmd`, so enabling a second is an *evaluation*
  error, not a runtime one.
- Host-specific hardware quirks (e.g. the laptop's `chuwi-minibook-x` module) get added as an extra module in that host's `modules = [ ... ]` list in `flake.nix`, and as an extra flake input if the module comes from elsewhere.
