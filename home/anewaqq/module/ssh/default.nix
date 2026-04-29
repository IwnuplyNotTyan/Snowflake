{ isDarwin, ... }:

let
  home = if isDarwin then "/Users/q" else "/home/q";
in

{
  age.secrets.ssh_ed25519 = {
    file = ./id_ed25519.age;
    path = "${home}/.ssh/id_ed25519";
  };

  age.secrets.ssh_rsa = {
    file = ./id_rsa.age;
    path = "${home}/.ssh/id_rsa";
  };

  age.identityPaths = [ "${home}/.config/age.txt" ];

  programs.ssh = {
    enable = true;
    
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      
      "Mikrotik" = {
        hostname = "192.168.1.1";
        user = "root";
        port = 22;
        identityFile = "~/.ssh/id_rsa";
        extraOptions = {
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
          HostKeyAlgorithms = "+ssh-rsa";
        };
      };
    };

    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
      IdentityFile ~/.ssh/id_rsa
    '';
  };
  
  #home.activation = {
  #  copySshKeys = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #    $DRY_RUN_CMD mkdir -p ~/.ssh
  #    $DRY_RUN_CMD chmod 700 ~/.ssh
  #    
  #    $DRY_RUN_CMD install -D -m 600 ${./id_ed25519} ~/.ssh/id_ed25519
  #    $DRY_RUN_CMD install -D -m 644 ${./id_ed25519.pub} ~/.ssh/id_ed25519.pub
  #    $DRY_RUN_CMD install -D -m 600 ${./id_rsa} ~/.ssh/id_rsa
  #    $DRY_RUN_CMD install -D -m 644 ${./id_rsa.pub} ~/.ssh/id_rsa.pub
  #  '';
  #};
}
