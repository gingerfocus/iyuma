{
  description = "nixos config";

  inputs = {
    # nixpkgs.url = github:nixos/nixpkgs/b69de56fac8c2b6f8fd27f2eca01dcda8e0a4221;

    nixpkgs.url = github:nixos/nixpkgs/24.11;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;
    hardware.url = github:NixOS/nixos-hardware/master;

    neomacs = {
      url = github:gingerfocus/neomacs;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    scripts = {
      url = github:gingerfocus/scripts;
      flake = false;
    };

    # zen-browser = {
    #   url = github:MarceColl/zen-browser-flake;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # This request each of the arguments from the flake registry. It is how you
  # get data from each thing you brought into scope.
  #
  # @ inputs to add it as an arg i think
  # The imports a map which is assined to this value each key is a thing that
  # can be build as config when no name is passed then `default` is built.
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ 
          # (final: prev: {
          #   wlroots_0_18 = prev.wlroots_0_18.overrideAttrs (old: { # you may need to use 0_18
          #     patches = (old.patches or [ ]) ++ [
          #       (prev.fetchpatch {
          #         url = "https://gitlab.freedesktop.org/wlroots/wlroots/uploads/bd115aa120d20f2c99084951589abf9c/DisplayLink_v2.patch";
          #         hash = "sha256-vWQc2e8a5/YZaaHe+BxfAR/Ni8HOs2sPJ8Nt9pfxqiE=";
          #       })
          #     ];
          #   });
          # }) 
      ];
    };

    pkgs-unstable = import nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    # Shared functions
    iyuma = {
      mkSystem = modules:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs system pkgs-unstable;};
          inherit system;
          modules = modules;
        };
      mkTool = name: code: {
        type = "app";
        program = "${pkgs.writeShellScriptBin name code}/bin/${name}";
      };
    };
  in {
    # run with `nix run .#stow`
    apps."${system}".stow = iyuma.mkTool "stow-config" ''
      ${pkgs.stow}/bin/stow --target $HOME/ --dotfiles stow
    '';

    formatter."${system}" = pkgs.alejandra;

    # run with `sudo nixos-rebuild switch --flake .#steamfunk`
    nixosConfigurations.steamfunk = iyuma.mkSystem [
      ./hosts/steamfunk

      ./modules/common.nix
      ./modules/desktop.nix
      # only for some times
      ./modules/work.nix

      ./modules/grub.nix
      inputs.hardware.nixosModules.framework-13th-gen-intel
    ];

    nixosConfigurations.hazed = iyuma.mkSystem [
      ./host/hazed

      ./modules/common.nix
      inputs.hardware.nixosModules.apple-macbook-pro-12-1
    ];
  };
}
