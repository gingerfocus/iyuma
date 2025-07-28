{
  config,
  pkgs,
  lib,
  usegrub ? false,
  ...
}: {
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.enable = !usegrub;

  # Grub Bootloader.
  boot.loader.grub = {
    enable = usegrub;
    devices = ["nodev"];
    efiSupport = true;
    configurationLimit = 5;

    ## See https://nx2.site/grub-ascii-theme for what is happening here.
    # theme = ./.;
    # font = "${pkgs.terminus_font}/share/fonts/terminus/ter-u32n.otb";
  };
}
