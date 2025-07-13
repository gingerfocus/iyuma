{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.efi.efiSysMountPoint = "/boot";

  # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  networking.hostName = "hazed";

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ----------------------------------- #
  # users.users.ginger = {
  #   isNormalUser = true;
  #   # description = "";
  #   shell = pkgs.bash;
  #   extraGroups = ["wheel" "audio" "video" "libvirtd"];
  # };
  # ----------------------------------- #

  system.stateVersion = "23.11";
}
