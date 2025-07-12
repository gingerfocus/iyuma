{
  inputs,
  pkgs,
  system,
  ...
}: {
  imports = [];

  environment.systemPackages = let
    doom-emacs = inputs.nix-doom-emacs.packages.${system}.default.override {
      # emacsPackage = pkgs.emacsPgtkNativeComp;
      # emacsPackage = pkgs.emacsPgtk;

      # doomPrivateDir = ./.;
      # doomPackageDir = ./.;
    };
  in [
    doom-emacs
  ];
}
