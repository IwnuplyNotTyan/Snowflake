{
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
	pubkeyAcceptedKeyTypes = "+ssh-rsa";
	hostKeyAlgorithms = "+ssh-rsa";
      };
    };
    
    extraConfig = ''
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
      IdentityFile ~/.ssh/id_rsa
    '';
  };

  home.file = {
  	# ED25519
    ".ssh/id_ed25519" = {
      source = ./id_ed25519;
      mode = "0600";
    };
    ".ssh/id_ed25519.pub" = {
      source = ./id_ed25519.pub;
      mode = "0644";
    };
    	# RSA
    ".ssh/id_rsa" = {
      source = ./id_rsa;
      mode = "0600";
    };
    ".ssh/id_rsa.pub" = {
      source = ./id_rsa.pub;
      mode = 0644;
    };
  };
}
