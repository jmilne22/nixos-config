# nixos-config

Personal NixOS flake configuration for multiple hosts.

## Layout

- `flake.nix` — defines a `nixosConfigurations.<hostname>` entry per machine
- `hosts/<hostname>/` — per-host config (`default.nix` + `hardware-configuration.nix`).
  Holds only what genuinely differs per machine: bootloader, hardware quirks,
  `networking.hostName`, `system.stateVersion`, and the list of modules to import.
- `modules/core.nix` — settings every machine gets; always imported
- `modules/desktops/` — pick **one** per host (`gnome.nix`, `plasma.nix`, `dwm/`).
  `desktops/displaymanagers/` holds greeters: pick **at most one**, and only on a host whose
  desktop doesn't already bring its own — `gnome.nix` brings gdm and `plasma.nix` brings sddm,
  so a greeter is for bare-WM hosts like dwm.
  `desktops/common/` is for plumbing shared between desktop modules — currently empty, and
  imported by those modules rather than from a host.
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

2. **Copy an existing host as a starting point** — pick whichever is closer to the new machine (`minibook` for a laptop-like device, `desktop` otherwise):

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
   - Adjust the `imports` list — swap the desktop (`modules/desktops/gnome.nix`, `plasma.nix`, `dwm/`) and app sets (`modules/apps/*.nix`) to whatever the new host needs
   - Drop/add any host-specific hardware modules (e.g. the minibook's `chuwi-minibook-x` block) as needed
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

## Chadwm session

`modules/desktops/dwm/` builds chadwm from the `chadwm` flake input, pinned in
`flake.lock`. The login session is still named **dwm**. The desktop host currently
also imports Plasma, so Plasma remains available in SDDM.

The module supplies a Nord-themed bar and Rofi launcher. Status shows memory,
network connectivity, default audio volume, date/time, and battery when present.
Picom and the status process run only for the dwm session and stop on logout.
The launcher button opens Rofi; the optional upstream Eww widget is not installed.

- `Super+Enter`: terminal; `Super+c`: applications.
- `Super+q`: close window; `Super+f`: fullscreen.
- `Super+Shift+r`: restart chadwm; `Super+Ctrl+q`: log out.
- Volume and brightness keys use PipeWire's PulseAudio interface and brightnessctl.

Theme, status text, and NixOS adaptations live in `modules/desktops/dwm/default.nix`.
The old `config.def.h` is preserved but is not used by chadwm. To return to Plasma
alone, remove the dwm import from `hosts/desktop/default.nix` and rebuild. To
restore vanilla dwm instead, restore the module's former package definition
using `pkgs.dwm.override { conf = ./config.def.h; patches = []; }` and remove
the unused chadwm helper definitions.

Validate with `nix eval --raw .#nixosConfigurations.desktop.config.system.build.toplevel.drvPath`
and build the window manager with
`nix build --no-link .#nixosConfigurations.desktop.config.services.xserver.windowManager.dwm.package`.

## Notes

- `result` / `result-*` are build symlinks and are gitignored — don't commit them. The
  pattern matches at any depth, so a stray `result` inside a subdirectory won't show up in
  `git status` but will still pin an old system closure as a GC root.
- Only one display manager can be enabled at a time. They all feed
  `services.displayManager.generic.execCmd`, so enabling a second is an *evaluation*
  error, not a runtime one.
- Host-specific hardware quirks (e.g. the minibook's `chuwi-minibook-x` module) get added as an extra module in that host's `modules = [ ... ]` list in `flake.nix`, and as an extra flake input if the module comes from elsewhere.
