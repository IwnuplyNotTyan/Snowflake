{ isDarwin, ... }:

{
services.syncthing = {
  enable = true;
  settings = {
    gui = { 
    	user = if isDarwin then "Anewaqq-mac" else "Eweless3";
    };
    devices = {
      "Merlinx" = { id = "L7CUYJH-7I7TYV3-3BAD5I7-35OTRR2-G6ZBNRP-DOAET6G-Y5CATHI-EU4B5QB"; };
      #"Eweless3" = { id = "3UV3CJG-4UMLMS4-N5MOFIC-A7QMIOP-PR4KFKZ-EPPNUG3-4245VNA-RH3S7AX"; };
    };
  };
};
}
