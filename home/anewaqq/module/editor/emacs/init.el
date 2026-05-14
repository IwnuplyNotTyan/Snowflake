(doom! :editor
       (evil +everywhere)
       :emacs
       dired
       :ui
       doom
       doom-dashboard
       modeline
       :tools
       (git +magit)
       :lang
       (org +roam2)
       nix
       go
       :config
       (default +bindings +smartparens))
