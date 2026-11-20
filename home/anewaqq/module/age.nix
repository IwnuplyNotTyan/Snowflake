{ config, ... }:

{
  age.identityPaths = [ "${config.home.homeDirectory}/.config/age.txt" ];
}
