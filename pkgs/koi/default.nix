{ lib, buildGoModule, fetchFromGitHub }:

 buildGoModule {
  pname = "koi";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "IwnuplyNotTyan";
    repo = "koi";
    rev = "e6c33efa33c378c16b793af380f51bc586a76e8e";
    sha256 = "sha256-nidqnPJG7uYg4R9g6LGw4ubcMkyBtAOHttkCamJ2CD0=";
  };

  vendorHash = "sha256-eNBgdxOd0vpcbam0iYXDmBZKFsFNqmJbXhP3qX4yPWk=";

  meta = {
    description = "Basic .md file reader";
    homepage = "https://github.com/IwnuplyNotTyan/koi";
    platforms = lib.platforms.all;
  };
}
