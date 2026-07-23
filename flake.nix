{
  description = "build with <3";

  inputs = {
    # Repository's
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # Unstable
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-25.11"; # 25.11

    # Addition stuff
    nixgl.url = "github:nix-community/nixGL"; # LibGL
    nix-index-database = {
      url = "github:nix-community/nix-index-database"; # Nix index
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix"; # Crypt
    waqq = {
      # Neovim dots
      url = "github:iwnuplynottyan/waqq";
      flake = false;
    };
    #nix-doom-emacs-unstraightened = {	# Emacs
	#url = "github:marienz/nix-doom-emacs-unstraightened";
    #};
    #emacs-overlay = {
    #	url = "github:nix-community/emacs-overlay";
    #	inputs.nixpkgs.follows = "nixpkgs";
    #};
    koi.url = "github:iwnuplynottyan/koi";
    #nix4gitbutler.url = "github:kmdtaufik/nix4gitbutler"; # Gitbutler
    #neru.url = "github:y3owk1n/neru";				# Mouse / Warpd analog
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
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      agenix,
      #neru,
      nix-index-database,
      nixgl,
      #nix4gitbutler,
      #emacs-overlay,
      home-manager,
      waqq,
      koi,
      #nix-doom-emacs-unstraightened,
      ...
    }:
    let
      mkHome =
        {
          system,
          isDarwin ? false,
        }:
        let
	pkgs = import nixpkgs {
	  inherit system;
	  overlays = 
	  #[ tetrigo.overlays.default ] ++
	    (nixpkgs.lib.optionals (!isDarwin) [ nixgl.overlay ]);
	    #++ (nixpkgs.lib.optionals isDarwin [ emacs-overlay.overlay ]);
	};
          pkgsUnstable = import nixpkgs-unstable { inherit system; };
          #miriPkg = pkgs.callPackage ./pkgs/miri/default.nix { };
	  mousewalkPkg = pkgs.callPackage ./pkgs/mousewalk/default.nix { 
	    python3PackagesUnstable = pkgsUnstable.python3Packages;
	  };
	  warpdPkg = pkgs.callPackage ./pkgs/warpd { };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/anewaqq/home.nix
            ./pkgs/miri/option.nix
            nix-index-database.hmModules.nix-index
            agenix.homeManagerModules.age
	    koi.homeManagerModules.default
	    #nix-doom-emacs-unstraightened.homeModule
            #neru.homeManagerModules.default
          ];
          extraSpecialArgs = {
            inherit
              pkgsUnstable
              isDarwin
              nix-index-database
              waqq
	      #nix4gitbutler
	      #nix-doom-emacs-unstraightened
              #miriPkg
	      koi
	      mousewalkPkg
	      warpdPkg
              ;
          };
        };

      system = "x86_64-linux";
    in
    {
      homeConfigurations.anewaqq = mkHome {
        system = "x86_64-linux";
        isDarwin = false;
      };

      homeConfigurations."anewaqq@darwin" = mkHome {
        system = "x86_64-darwin";
        isDarwin = true;
      };

      nixosConfigurations.eweless3 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./host/eweless3/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.q = import ./home/anewaqq/home.nix;
          }
        ];
      };

      nixosConfigurations.lira = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          {
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
