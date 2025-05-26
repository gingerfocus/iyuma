{
  config,
  pkgs,
  ...
}: {
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.loader.systemd-boot.enable = true;

  # Grub Bootloader.
  boot.loader.grub = {
    enable = true;
    memtest86.enable = true;
    # device = "/dev/disk/by-uuid/D442-50BC";
    devices = ["nodev"];
    efiSupport = true;
    configurationLimit = 5;
    # useOSProber = true;
    # font = path
    # fontSize = uint
    # theme = string
  };

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "catppuccin-mocha";
  # boot.plymouth.themePackages = [pkgs.catppuccin-plymouth];
}
