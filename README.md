# ✨ Nix dotfiles

> [!WARNING]
> Not tested on non x86-64 systems, non intel's and Nixos support dropped

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

## 🎏 Special thank's
**Nixos RU Community** - Telegram chat 
