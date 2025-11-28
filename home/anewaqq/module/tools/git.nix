{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    userName = "IwnuplyNotTyan";
    userEmail = "wolflast21@gmail.com";
    
    extraConfig = {
      credential."https://github.com" = {
        helper = "";
        helper = "!/run/current-system/sw/bin/gh auth git-credential";
      };
      
      credential."https://gist.github.com" = {
        helper = "";
        helper = "!/run/current-system/sw/bin/gh auth git-credential";
      };
      
      credential."http://lira.iwnuply.store:3000" = {
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
    };
  };
}
