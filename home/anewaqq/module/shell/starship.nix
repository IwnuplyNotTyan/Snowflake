{
  programs.starship = {
    enable = true;

    settings = {
      aws = {
        style = "bold #ffb86c";
      };

      character = {
        error_symbol   = "[λ](bold #df5b61)";
        success_symbol = "[λ](bold  #87c7a1)";
      };

      cmd_duration = {
        style = "bold #f1fa8c";
      };

      directory = {
        style = "bold #96d6b0";
      };

      package = {
        symbol = "󰏖 ";
        style  = "bold #96d6b0";
      };

      ruby = {
        symbol = " ";
        style  = "bold #ee6a70";
      };

      fennel = {
        symbol = " ";
        style  = "bold #7fc8db";
      };

      kotlin = {
        symbol = " ";
        style  = "bold #cb92f2";
      };

      java = {
        symbol = " ";
        style  = "bold #ee6a70";
      };

      golang = {
        symbol = " ";
        style  = "bold #7ba5dd";
      };

      lua = {
        symbol = " ";
        style  = "bold #cb92f2";
      };

      c = {
        symbol = " ";
        style  = "bold #7fc8db";
      };

      python = {
        symbol = " ";
        style  = "bold #7ba5dd";
      };

      nodejs = {
        symbol = "󰎙 ";
        style  = "bold #de8f78";
      };

      php = {
        symbol = " ";
        style  = "bold #7ba5dd";
      };

      haskell = {
        symbol = " ";
        style  = "bold #96d6b0";
      };

      git_branch = {
        symbol = " ";
        style  = "bold #de8f78";
      };

      git_status = {
        style = "bold #de8f78";
      };

      git_commit = {
        style = "bold #de8f78";
      };

      docker_context = {
        symbol = " ";
        style  = "bold #7ba5dd";
      };

      gcloud = {
        symbol = "󱇶 ";
        style  = "bold #de8f78";
      };

      nix_shell = {
        symbol = "󱄅 ";
        style  = "bold #7ba5dd";
      };

      hostname = {
        style = "bold #bd93f9";
      };

      username = {
        format     = "[$user]($style) on ";
        style_user = "bold #8be9fd";
      };
    };
  };
}
