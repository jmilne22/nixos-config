# CLAUDE.md

Personal NixOS flake config, two hosts (`desktop`, `minibook`), tracking `nixos-unstable`.

`README.md` covers the directory layout and how to add a host — read it rather than
re-deriving the structure. This file covers what's specific to working here as an agent.

## Use the `nixos` MCP server

`.mcp.json` registers `mcp-nixos`. **Check package names and option paths against it before
writing them into a module**, even when you're confident:

- `nix {"action":"info","query":"<pkg>","channel":"unstable"}` — does this package exist?
- `nix {"action":"search","query":"<prefix>","type":"options"}` — what is the real option path?
- `nix {"action":"info","query":"<option>","type":"option"}` — type, default, description

This flake tracks unstable, where options get renamed with no deprecation window (`ly` moved
from `services.xserver.displayManager.ly` to `services.displayManager.ly`). Guessing from
memory produces plausible-looking attrs that fail at eval, or worse, silently do nothing.

The server queries live search.nixos.org, not `flake.lock`. It's the right tool for "does this
option exist and what is it called", not for "what exactly will this machine build".

## Verifying a change

Eval-check without building or leaving a `result` symlink:

```
nix eval --raw .#nixosConfigurations.desktop.config.system.build.toplevel.drvPath
```

Success means it evaluated — module names, option paths, and types all resolved. It does not
mean the packages build.

`.#minibook` does not evaluate and that is expected, not something to fix: the host isn't
installed yet, so `hosts/minibook/hardware-configuration.nix` doesn't exist. It fails with
`Path '...' does not exist in Git repository`. For the same reason, `nix flake check` is not
useful here — it tries every host.

Flakes read from git, not the working tree, so a **new** file is invisible to eval until it's
at least `git add`ed. Editing an already-tracked file needs no staging.

## Conventions

- Every module opens `{ config, pkgs, ... }:` and returns a plain config attrset. There is no
  `options`/`mkIf`/`enable`-flag plumbing anywhere — composition happens by choosing which
  files a host imports, not by toggles inside them.
- A module owns everything for its concern, services included. `apps/gaming.nix` enables Steam
  and gamemode and adds the uinput group, not just packages.
- Host `default.nix` holds only what differs per machine: bootloader, hardware quirks,
  `networking.hostName`, `system.stateVersion`, and the `imports` list.
- Adding a module to a host means adding a line to that host's `imports`. Adding a *host* also
  means an entry in `flake.nix`.
- One desktop per host; at most one display manager, and none on a host whose desktop already
  brings its own (gnome→gdm, plasma→sddm).

## Don't

- Run `nixos-rebuild switch` — it needs sudo and changes the running system. Suggest it, let
  the user run it.
- Commit or push unless asked.
- Commit `result` / `result-*` symlinks (gitignored, but they pin old closures as GC roots).
