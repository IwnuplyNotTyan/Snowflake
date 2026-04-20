{
  description = "build with <3";

  inputs = {
	# Repository's
    	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Unstable
    	nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.11";
	
	# Addition stuff
    	nixgl.url = "github:nix-community/nixGL";
  	#disko = {
  	#  url = "github:nix-community/disko";
  	#  inputs.nixpkgs.follows = "nixpkgs";
  	#};
	#nixos-anywhere = {
 	#   url = "github:nix-community/nixos-anywhere";
 	#   inputs.nixpkgs.follows = "nixpkgs";
 	#   inputs.disko.follows = "disko";
 	#};

	# Home manager
	home-manager = {
    	  url = "github:nix-community/home-manager";
    	  inputs.nixpkgs.follows = "nixpkgs";
    	};

    	# Nix-on-droid
    	nix-on-droid = {
    	  url = "github:nix-community/nix-on-droid/release-24.05";
    	  inputs.nixpkgs.follows = "nixpkgs";
    	  inputs.home-manager.follows = "home-manager";
    	};
  };
  
  outputs = { nixpkgs, nixpkgs-unstable, nixgl, home-manager, nix-on-droid, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
      inherit system;
	  overlays = [ nixgl.overlay ];
      };
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
    in {
      homeConfigurations.anewaqq = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/anewaqq/home.nix ];
	extraSpecialArgs = { inherit pkgsUnstable; };
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
            home-manager.users.q = import ./home/anewaqq/home.nix;
          }
        ];
	};

	nixOnDroidConfigurations.nod = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [
	 ./host/nod/configuration.nix
	           {
            home-manager = {
              config = ./host/nod/home.nix;
              backupFileExtension = "hm-bak";
              useGlobalPkgs = true;
            };
	    }
	 ];
      };

     nixosConfigurations.lira = nixpkgs.lib.nixosSystem {
	inherit system;
	modules = [
	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.q = import ./home/anewaqq/home.nix;
          }
	  #disko.nixosModules.disko
	  ./host/lira/configuration.nix
	];
      };
    };
}

