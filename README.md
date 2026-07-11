<div align="center">
  <h1>❄️ ~ Snowflake</h1>
  <p>Nix dotfiles</p>
</div>

<p align="center">
  <img src="https://github.com/IwnuplyNotTyan/Snowflake/blob/main/.github/assets/screenshot.png?raw=true" alt="Screenshot">
</p>

---

> [!WARNING]
> Not tested on non x86-64 systems, non intel's and Nixos support dropped

# ✨ Features of config

- OS - Arch Based / MacOS
- WM - [https://i3wm.org/] / [SwayFX](https://github.com/WillPower3309/swayfx) / Aqua
- Shell - [Zsh](https://zsh.org)
- Term - [Kitty](https://sw.kovidgoyal.net/kitty/) + [Tmux](https://github.com/tmux/tmux)
- Music - [Rmpc](https://rmpc.mierak.dev/)
- Widgets - [EWW](https://github.com/elkowar/eww)
- Comp - [Picom](https://picom.com)
- Spotlight - [Vicinae](https://github.com/vicinaehq/vicinae/) / [Raycast](https://www.raycast.com/)
- Editor - [Neovim](https://github.com/neovim/neovim) v0.11.7, [dots](https://github.com/IwnuplyNotTyan/waqq)

---

## 🕊️ Installing

### 🍏 For Darwin_x86-64
```sh
NIXPKGS_ALLOW_BROKEN=1 nix build .#homeConfigurations.anewaqq@darwin.activationPackage --impure
```

### 🏳️‍⚧️ For Linux_x86-64
```sh
nix build .#homeConfigurations.anewaqq.activationPackage
```

---

## 🐙 HostName's

| Hostname | Arch | Desc | Status |
|----------|------|------|--------|
|Lira|Linux_x86-64|Basic system with docker & tailscale| ❌ |
|Eweless3|Linux_x86-64|Built for nixos| ❌ |
|Anewaqq|Linux_x86-64|Home manager settings| ✅ |
|Anewaqq@darwin|Darwin_x86-64|HM mac version| ✅ |
|nod|Aarch64-linux|HM termux verson, broken | ❌* |

`*` - Commented

---

## 🎏 Flake inputs

|Type|Name|Input|Desc|
|----|----|-----|----|
|❄️|[Nixpkgs](https://github.com/nixos/nixpkgs)|pkgs|Stable Package Repo|
|❄️|Nixpkgs Unstable|pkgsUnstable|Unstable Package Repo|
|❄️|[Home Manager](https://github.com/nix-community/home-manager)|home-manager|Manage a user environment|
|❄️|[NixGL](https://github.com/nix-community/nixgl)|nixgl|LibGL for non nixos distro's|
|❄️|[Nix Index Database](https://github.com/nix-community/nix-index-database)|nix-index-database|Index Nix Packages, In general for ,|
|❄️|[Agenix](https://github.com/ryantm/agenix)|agenix|Age encrypt|
|✨|[Waqq](https://github.com/IwnuplyNotTyan/waqq)|waqq|My neovim dots|
|✨|[Koi](https://github.com/IwnuplyNotTyan/Koi)|koi|.MD Reader|

❄️ - System Side

✨ - Apps

---

## 🪻 File Tree
```
.
├── flake.lock
├── flake.nix        # Main file
├── home             # For home manager hostnames
│   └── anewaqq      # HM hostname (Main)
│       ├── home.nix # Home manager settings
│       ├── module   # All config's
│       └── pkgs.nix # Pkg list
├── host             # For eweless3, lira and nod hostname's
└── pkgs             # Self written packages
```

---

## 🎏 Special thank's
**Nixos RU Community** - Telegram chat 
