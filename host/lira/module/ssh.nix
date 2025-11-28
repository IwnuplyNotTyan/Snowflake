{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASrrslPtlvKOXsbYo8mc4IB5bHFuFbGCcWLXRxjEo90 q@eweless3"
  ];
}
