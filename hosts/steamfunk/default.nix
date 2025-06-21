{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "steamfunk";

  # firmware updates
  services.fwupd.enable = true;

  system.stateVersion = "23.11";
}
