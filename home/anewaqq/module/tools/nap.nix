{ pkgs, config, ... }:

{
  ## This export doesn't work, file's path in ~/.local/share/nap/*
  ## Rewrite or wibecode path if needed )

  #home.sessionVariables = {
  #  NAP_HOME = "${config.home.homeDirectory}/files/snippets";
  #};

  home.packages = with pkgs; [
    nap
  ];
}
