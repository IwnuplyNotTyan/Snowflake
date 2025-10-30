{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  
  systemd.tmpfiles.rules = [
    "d /home/q/files/docker 0755 q q -"
    "d /home/q/files/docker/beszel_data 0755 q q -"
    "d /home/q/files/docker/beszel_agent_data 0755 q q -"
    "d /home/q/files/docker/syncthing 0755 q q -"
    "d /home/q/files/docker/syncthing-data 0755 q q -"
    "d /home/q/files/docker/jellyfin-config 0755 q q -"
    "d /home/q/files/docker/jellyfin-cache 0755 q q -"
    "d /home/q/files/docker/qbittorrent 0755 q q -"
    "d /home/q/files/docker/gitea 0755 q q -"
    "d /home/q/files/docker/postgres 0755 q q -"
    "d /home/q/files/docker/nix-container 0755 q q -"
    "d /home/q/downloads 0755 q q -"
    "d /home/q/files/media 0755 q q -"
  ];

  systemd.services.docker-network-setup = {
    description = "Create Docker networks";
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.docker}/bin/docker network inspect gitea-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create gitea-net
      ${pkgs.docker}/bin/docker network inspect media-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create media-net
      ${pkgs.docker}/bin/docker network inspect nix-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create nix-net
    '';
  };

  virtualisation.oci-containers = {
    backend = "docker";
    
    containers = {
      uptime-kuma = {
        image = "louislam/uptime-kuma:1";
        ports = [ "3001:3001" ];
        volumes = [
          "uptime_kuma_data:/app/data"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];
        extraOptions = [ "--restart=unless-stopped" ];
      };

      beszel = {
        image = "henrygd/beszel";
        ports = [ "8090:8090" ];
        volumes = [ "/home/q/files/docker/beszel_data:/beszel_data" ];
        extraOptions = [ "--restart=unless-stopped" ];
      };

      beszel-agent = {
        image = "henrygd/beszel-agent";
        environment = {
          LISTEN = "45876";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDx8k8t82cTzBOdIEUVgaRELwDUDnkxAR7oFGYLgrNxN";
          TOKEN = "88fe0668-eab3-4ded-b9d1-454dbfc52a41";
          HUB_URL = "http://lira.welara-sun.ts.net:8090";
        };
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "/home/q/files/docker/beszel_agent_data:/var/lib/beszel-agent"
          "/mnt/sda/.beszel:/extra-filesystems/sdb1:ro"
        ];
        extraOptions = [ 
          "--restart=unless-stopped"
          "--network=host"
        ];
      };

      syncthing = {
        image = "lscr.io/linuxserver/syncthing:latest";
        hostname = "Lira";
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
        };
        ports = [
          "8384:8384"
          "22000:22000"
          "22000:22000/udp"
          "21027:21027/udp"
        ];
        volumes = [
          "/home/q/files/docker/syncthing:/config"
          "/home/q/files/docker/syncthing-data:/data1"
        ];
        extraOptions = [ "--restart=unless-stopped" ];
      };

      jellyfin = {
        image = "linuxserver/jellyfin";
        ports = [ "8096:8096" ];
        volumes = [
          "/home/q/files/docker/jellyfin-config:/config"
          "/home/q/files/docker/jellyfin-cache:/cache"
          "/home/q/files/media:/media/main"
          "/mnt/sda/media:/media/disk"
        ];
        extraOptions = [
          "--restart=unless-stopped"
          "--privileged"
          "--device=/dev/dri:/dev/dri"
          "--network=media-net"
        ];
      };

      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
          WEBUI_PORT = "8080";
          TORRENTING_PORT = "6881";
          DOCKER_MODS = "ghcr.io/gabe565/linuxserver-mod-vuetorrent";
        };
        ports = [
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
        ];
        volumes = [
          "/home/q/files/docker/qbittorrent:/config"
          "/home/q/downloads:/downloads"
          "/home/q/files/media:/media"
          "/mnt/sda:/disk"
        ];
        extraOptions = [
          "--restart=unless-stopped"
          "--network=media-net"
        ];
      };

      gitea-db = {
        image = "postgres:14-alpine";
        environment = {
          POSTGRES_USER = "gitea";
          POSTGRES_PASSWORD = "gitea";
          POSTGRES_DB = "gitea";
        };
        volumes = [ "/home/q/files/docker/postgres:/var/lib/postgresql/data" ];
        extraOptions = [
          "--restart=always"
          "--network=gitea-net"
          "--health-cmd=pg_isready -U gitea"
          "--health-interval=30s"
          "--health-timeout=10s"
          "--health-retries=3"
        ];
      };

      gitea = {
        image = "gitea/gitea:1.21.3";
        dependsOn = [ "gitea-db" ];
        environment = {
          USER_UID = "1000";
          USER_GID = "1000";
          GITEA__database__DB_TYPE = "postgres";
          GITEA__database__HOST = "gitea-db:5432";
          GITEA__database__NAME = "gitea";
          GITEA__database__USER = "gitea";
          GITEA__database__PASSWD = "gitea";
          GITEA__server__DOMAIN = "100.99.1.1";
          GITEA__server__ROOT_URL = "http://100.99.1.1:3000/";
          GITEA__server__HTTP_ADDR = "0.0.0.0";
        };
        ports = [
          "3000:3000"
          "222:22"
        ];
        volumes = [
          "/home/q/files/docker/gitea:/data"
          "/etc/timezone:/etc/timezone:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--restart=always"
          "--network=gitea-net"
        ];
      };

      tailscale-nix = {
        image = "tailscale/tailscale:latest";
        environment = {
          TS_AUTHKEY = "tskey-auth-kzWvxCu8PB21CNTRL-pq7RUJtPZTLes6qhsoDrTLJbKE3bmqZ3";
          TS_HOSTNAME = "lotus";
          TS_STATE_DIR = "/var/lib/tailscale";
          TS_EXTRA_ARGS = "--advertise-tags=tag:container";
        };
        volumes = [
          "/home/q/files/docker/nix-container/tailscale:/var/lib/tailscale"
          "/dev/net/tun:/dev/net/tun"
        ];
        extraOptions = [
          "--restart=unless-stopped"
          "--network=nix-net"
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_MODULE"
        ];
      };

      lotus-one = {
        image = "nixos/nix:latest";
        dependsOn = [ "tailscale-nix" ];
        cmd = [
          "while true; do echo 'Nix container running...'; sleep 3600; done"
        ];
        volumes = [
          "/home/q/files/docker/nix-container/nix:/nix"
          "/home/q/files/docker/nix-container/home:/root"
        ];
        extraOptions = [
          "--restart=unless-stopped"
          "--network=container:tailscale-nix"
        ];
      };
    };
  };

  systemd.services."docker-lotus-one".serviceConfig = {
    CPUQuota = "100%"; # 1 Core
    MemoryLimit = "1G";
  };
}
