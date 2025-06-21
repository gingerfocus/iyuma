{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    evdi
  ];

  environment.variables = {
    WLR_EVDI_RENDER_DEVICE = "/dev/dri/card1";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.xserver.videoDrivers = ["displaylink" "modesetting"];
  systemd.services.dlm.wantedBy = ["multi-user.target"];

  environment.systemPackages = with pkgs; [
    displaylink
    chromium
  ];
}
