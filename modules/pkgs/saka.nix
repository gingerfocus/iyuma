{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  saka = inputs.saka.packages.${system}.default;
in {
  security.wrappers.saka = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${saka}/bin/saka";
  };

  environment.systemPackages = [
    saka
  ];

  # security.pam.services.saka = {
  #   allowNullPassword = true;
  #   sshAgentAuth = true;
  # };
}
