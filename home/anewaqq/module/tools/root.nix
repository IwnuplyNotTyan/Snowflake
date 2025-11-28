{ config, pkgs, ... }:

{
  security = {
    doas = {
	enable = true;
  	extraConfig = ''
  	permit persist keepenv :wheel
  	'';
  	};
    sudo = {
	enable = false;
    };
  };

}
