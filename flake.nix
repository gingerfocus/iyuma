{
  description = "Stupid dumb very bad sysconf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    # user configurations
    homeConfigurations = {
      focus = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs outputs self;};
        modules = [
          ./users/focus/home.nix
        ];
      };
      fears = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs outputs self;};
        modules = [
          ./users/fears/home.nix
        ];
      };
    };

    # host configurations
    nixosConfigurations = {
      steambox = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/steambox];
      };
      hazed = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/hazed];
      };
    };

    steambox = self.nixosConfigurations.steambox.config.system.build.toplevel;
    hazed = self.nixosConfigurations.hazed.config.system.build.toplevel;
  };
}
