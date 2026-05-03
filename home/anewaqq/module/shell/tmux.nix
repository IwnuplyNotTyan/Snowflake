{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    historyLimit = 50000;
    keyMode = "vi";

    extraConfig = ''
      # Bar
      set -g message-style 'bg=default,fg=yellow,bold'
      set -g status-style  'bg=default'

      # Titles
      set -g set-titles on
      set -g set-titles-string '#{window_index}.#{pane_index} ☞ #{pane_current_command}'

      # Pane borders
      %if "#{!=:$SSH_CONNECTION,}"
      set -gF pane-border-style        '#{?pane_synchronized,fg=#ee6a70,fg=blue}'
      set -gF pane-active-border-style '#{?pane_synchronized,fg=#ee6a70,fg=#ffb29b}'
      %else
      set -gF pane-border-style        '#{?pane_synchronized,fg=#ee6a70,fg=white}'
      set -gF pane-active-border-style '#{?pane_synchronized,fg=#ee6a70,fg=green}'
      %endif
      set -g pane-border-format "(#{pane_index}) #{pane_title} → #{pane_current_command}"

      # Mode style
      setw -g mode-style 'bg=#96d6b0, fg=#c5c8c9, bold'

      # Status line
      set -g status-interval  4
      set -g status-position  bottom
      set -g status-justify   left
      set -g status-right        ""
      set -g status-right-length 0

      set -g @online_icon  "#[fg=#96d6b0,none] #[default]"
      set -g @offline_icon "#[fg=#ee6a70,none]󱛅 #[default]"

      set -g  status-left '#[fg=black,bold,bg=#96d6b0]#{pane_mode}#[fg=#96d6b0,none]'
      set -ga status-left '#{?client_prefix,#[bg=default],#[bg=default]} #[fg=#c5c8c9,bold]#S#[fg=none] '
      set -ga status-left '#[bg=default]#{?client_prefix,#[fg=#c5c8c9,#[fg=default]  }'
      set -g  status-left-length 80

      setw -g window-status-activity-style fg=#ffb29b
      setw -g window-status-bell-style     fg=#ee6a70
      setw -g window-status-format         "#[fg=#ffb29b]#I#[fg=#96d6b0]#F #[fg=#c5c8c9]#W"
      setw -g window-status-current-format "#[fg=#ffb29b]#I#[fg=#96d6b0]#F #[fg=#c5c8c9,bold,underscore]#W"
      setw -g window-status-separator      "#[fg=#c5c8c9,bold]  "

      # Terminal
      set-option -ga terminal-overrides ",*256col*:Tc"
      set-option -sa terminal-overrides ",xterm-kitty:Tc"
      set-option -as terminal-features  ',xterm-kitty:RGB'
      set-option -as terminal-features  ',xterm-kitty:usstyle'
      set-option -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
      set-option -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set-option -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      set -g status-style               bg=terminal,fg=terminal
      set -g window-status-current-style fg=terminal,bold

      # Basic
      set-window-option -g  automatic-rename on
      set-window-option -gq utf8 on
      set-window-option -g  monitor-activity on
      set-option -g  set-clipboard on
      set-option -g  focus-events on
      set-option -g  display-time 5000
      setw -g pane-base-index 1

      # Keys
      bind s choose-tree -sZ -O name
      bind x kill-pane
      bind X kill-window
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind -T copy-mode-vi WheelUpPane   select-pane \; send-keys -X -N 2 scroll-up
      bind -T copy-mode-vi WheelDownPane select-pane \; send-keys -X -N 2 scroll-down

      # Resize
      set-option -g @pane_resize "10"
      bind-key -r -T prefix C-Up    resize-pane -U
      bind-key -r -T prefix C-Down  resize-pane -D
      bind-key -r -T prefix C-Left  resize-pane -L
      bind-key -r -T prefix C-Right resize-pane -R
    '';
  };
}
