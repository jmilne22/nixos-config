{ config, pkgs, ... }:
{
  # libvirt + QEMU/KVM. The daemon does the work; virt-manager is just a UI on
  # top of it, so both belong here rather than one being a bare package.
  virtualisation.libvirtd = {
    enable = true;

    # Don't resurrect whatever was running when the host went down - these are
    # throwaway test VMs, not services. Guests marked autostart still start.
    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu = {
      # Emulated TPM, so a guest that insists on TPM 2.0 (Windows 11) installs.
      swtpm.enable = true;

      # virtiofs shared folders between host and guest. Needs an out-of-tree
      # vhost-user driver, which is what this option exists to register.
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  # UEFI firmware needs no configuration: virtualisation.libvirtd.qemu.ovmf was
  # removed from nixpkgs and now trips an assertion if set. Every OVMF image
  # QEMU ships is exposed to libvirt by default, so tutorials predating that
  # removal will tell you to set an option that no longer evaluates.

  programs.virt-manager.enable = true;

  # Pass a physical USB device through to a guest as an unprivileged user.
  virtualisation.spiceUSBRedirection.enable = true;

  # Membership in this group is what lets the user talk to the daemon at all -
  # without it virt-manager can only see the read-only qemu:///session URI.
  users.users.user.extraGroups = [ "libvirtd" ];
}
