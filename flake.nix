{
  description = "nixos config";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/25.11;
    nixpkgs-unstable.url = github:nixos/nixpkgs/nixpkgs-unstable;

    hardware.url = github:NixOS/nixos-hardware/master;

    neomacs = {
      url = "github:gingerfocus/neomacs?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    saka = {
      url = github:gingerfocus/saka;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = github:0xc000022070/zen-browser-flake;
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = null;
    };
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
    # nixpkgs-stable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-unstable = import nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };

    # pkgs-stable = import nixpkgs-stable {
    #   inherit system;
    # };

    # Shared functions
    iyuma = {
      mkSystem = modules: args:
        nixpkgs.lib.nixosSystem {
          specialArgs = args // {inherit inputs system pkgs-unstable ;
          # pkgs-stable;
          };
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
    nixosConfigurations.steamfunk =
      iyuma.mkSystem [
        ./hosts/steamfunk
        ./modules/common.nix
        ./modules/desktop.nix

        ## only for some times
        ./modules/games.nix

        inputs.hardware.nixosModules.framework-13th-gen-intel
      ] {
        usegrub = true;
      };

    nixosConfigurations.hazed =
      iyuma.mkSystem [
        ./hosts/hazed
        ./modules/common.nix

        inputs.hardware.nixosModules.apple-macbook-pro-12-1
      ] {
        usegrub = false;
      };

    devShells."${system}".default = pkgs.mkShell {
      buildInputs = with pkgs; [
        lua-language-server
        stylua
        alejandra
      ];
    };
  };
}
