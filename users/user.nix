{ config, pkgs, ... }:
{
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
