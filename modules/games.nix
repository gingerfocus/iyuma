{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    ### Games
    # (lutris.override {
    #   steamSupport = true;
    #   extraLibraries =  pkgs: [
    #     # List library dependencies here
    #   ];
    #   extraPkgs = pkgs: [
    #      # List package dependencies here
    #   ];
    # })
    #
    # adwaita-icon-theme

    heroic
  ];

  # hardware.graphics.enable32Bit = true;
}
