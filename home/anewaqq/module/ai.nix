{ pkgs, pkgsUnstable, lib, isDarwin, ... }:

{
  home.packages = [
   # pkgsUnstable.ollama
  ] ++ lib.optionals (isDarwin) [
    pkgs.nodejs
  #] ++ lib.optionals (!isDarwin) [
    pkgsUnstable.opencode
  ];

  home.activation.installOpencode = lib.mkIf isDarwin (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export npm_config_prefix="$HOME/.npm-global"
    mkdir -p "$HOME/.npm-global/bin"
    if ! command -v opencode &>/dev/null; then
      $DRY_RUN_CMD npm install -g opencode-ai
    fi
  '');
}
