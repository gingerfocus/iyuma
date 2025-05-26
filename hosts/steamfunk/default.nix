{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  networking.hostName = "steamfunk";

  system.stateVersion = "23.11";
}
