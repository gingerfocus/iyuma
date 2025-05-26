{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  neomacs = inputs.neomacs.packages.${system}.default;
in {
  environment.systemPackages = [
    neomacs
  ];
}
