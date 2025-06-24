{
  config,
  pkgs,
  lib,
  ...
}: let
  usegrub = false;
in {
  boot.loader.systemd-boot.enable = !usegrub;

  # Grub Bootloader.
  boot.loader.grub = {
    enable = usegrub;
    # memtest86.enable = true;
    # device = "/dev/disk/by-uuid/D442-50BC";
    devices = ["nodev"];
    efiSupport = true;
    configurationLimit = 5;

    # See https://nx2.site/grub-ascii-theme for what is happening here.
    theme = ./.;
    font = "${pkgs.terminus_font}/share/fonts/terminus/ter-u32n.otb";
  };
}
