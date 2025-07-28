{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  environment.systemPackages = [
    # inputs.neomacs.packages.${system}.default
    pkgs.emacs-pgtk
  ];
}
