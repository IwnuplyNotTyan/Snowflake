{
  description = "build with <3";

  inputs = {
	# Repository's
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nur = {
    #  url = "github:nix-community/NUR";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
	# Addition stuff
    #nixgl.url = "github:nix-community/nixGL";
	# Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { nixgl, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
      inherit system;
	  overlays = [ nixgl.overlay ];
      };
    in {
      homeConfigurations.anewaqq = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
	./home.nix
	#./home/anewaqq
	];
      };
      
      nixosConfigurations.anewaqq = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.q = import ./home.nix;
	  }
	];
      };
      
      nixosConfigurations.eweless3 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./host/eweless3/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.q = import ./home.nix;
          }
        ];

      nixosConfigurations.lira = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [
	  ./host/lira/configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.q = import ./home.nix;
	  }
	];
      }
      };
    };
}

