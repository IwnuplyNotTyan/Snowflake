{ pkgs, pkgsUnstable, ... }:

{
  programs = {
    zsh = {
      enable = true;

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          file = "share/zsh/site-functions/zsh-completions.plugin.zsh";
        }
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          src = pkgs.fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "v1.0";
            sha256 = "sha256-3zvOgIi+q7+sTXrT+r/4v98qjeiEL4Wh64rxBYnwJvQ=";
          };
          file = "autopair.zsh";
        }
        {
          name = "cd-ls";
          src = pkgs.fetchFromGitHub {
            owner = "zshzoo";
            repo = "cd-ls";
            rev = "main";
            sha256 = "sha256-1tkh7l2TRnji70/fiI7Qtk11MzBv6+iy8tswead3KL8=";
          };
          file = "cd-ls.plugin.zsh";
        }
      ];

      envExtra = ''
        export PATH="$HOME/files/bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/.local/share/npm/bin:$PATH"
      '';

      sessionVariables = {
        VISUAL = "nvim";
        EDITOR = "nvim";
        CD_LS_COMMAND = "exa --icons --color=always --reverse";
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#cccccc,bg=none,italic,underline";
      };

      shellAliases = {
        ":q" = "exit";
        e = "exa --icons --color=always --reverse";
        el = "exa --icons --color=always --reverse --git -l --all";
        et = "exa --icons --tree --color=always --reverse";
      };

      initContent = ''
        autoload -U compinit; compinit
        zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
        zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
        zstyle ':completion:*' file-list change reverse all

        autopair-init
        typeset -gA AUTOPAIR_PAIRS
        bindkey "<" autopair-insert
        AUTOPAIR_PAIRS+=("<" ">")
        AUTOPAIR_LBOUNDS=(all '[.:/\!]')
        AUTOPAIR_LBOUNDS+=(quotes '[]})a-zA-Z0-9]')
        AUTOPAIR_LBOUNDS+=(spaces '[^{([]')
        AUTOPAIR_LBOUNDS+=(braces "")
        AUTOPAIR_LBOUNDS+=('`' '`')
        AUTOPAIR_LBOUNDS+=('"' '"')
        AUTOPAIR_LBOUNDS+=("'" "'")
        AUTOPAIR_RBOUNDS=(all '[[{(<,.:?/%$!a-zA-Z0-9]')
        AUTOPAIR_RBOUNDS+=(quotes '[a-zA-Z0-9]')
        AUTOPAIR_RBOUNDS+=(spaces '[^]})]')
        AUTOPAIR_RBOUNDS+=(braces "")
      '';
    };

    atuin = {
      enable = true;
      package = pkgsUnstable.atuin;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
