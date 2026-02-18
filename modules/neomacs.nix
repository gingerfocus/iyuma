{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # inputs.neomacs.packages.${system}.default

    typst
    tinymist

    (
      (emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: [
        epkgs.vterm
        # epkgs.emacs-libvterm
      ])
    )

    # (
    #   pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
    #     vterm
    #   ]))
    # )
  ];
}
