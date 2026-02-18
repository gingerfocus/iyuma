{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  services.xserver.windowManager.i3.enable = true;
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    omnissa-horizon-client
  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
    ];
  };

  networking.networkmanager.plugins = with pkgs; [
    # networkmanager-fortisslvpn
    # networkmanager-iodine
    # networkmanager-l2tp
    networkmanager-openconnect
    # networkmanager-openvpn
    # networkmanager-sstp
    # networkmanager-strongswan
    # networkmanager-vpnc
  ];
}
