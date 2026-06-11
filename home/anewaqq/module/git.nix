{ pkgs, pkgsUnstable, lib, isDarwin, ... }:

{
  home.packages = with pkgs; [
    git-lfs
    lazygit
    github-cli
    diffnav
    git
  ];

  programs.git = {
    enable = true;
    
    userName = "IwnuplyNotTyan";
    userEmail = "ikissiwnuply@gmail.com";
    
    extraConfig = {
	} // lib.optionalAttrs (!isDarwin) {
  	credential."https://github.com" = {
    	  helper = "/home/q/.nix-profile/bin/gh auth git-credential";
      };
        credential."https://gist.github.com" = {
    	  helper = "/home/q/.nix-profile/bin/gh auth git-credential";
        };
      } // lib.optionalAttrs isDarwin {
	credential."https://github.com" = {
	  helper = "/Users/q/.nix-profile/bin/gh auth git-credential";
      };
  	credential."https://gist.github.com" = {
    	  helper = "/Users/q/.nix-profile/bin/gh auth git-credential";
      };
      credential."http://lira.iwnuply.store:3000" = {
        helper = "store";
      };

      credential."https://lira.welara-sun.ts.net" = {
        helper = "store";
      };
      
      http = {
        lowSpeedLimit = 1000;
        lowSpeedTime = 60;
        postBuffer = 524288000;
      };
      
      filter.lfs = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
      };

      pager.diff = "diffnav";
    };
  };

programs.gh = {
  enable = true;
  gitCredentialHelper.enable = false;
  extensions = [
    pkgsUnstable.gh-dash
    pkgsUnstable.gh-eco
  ];
};
}
