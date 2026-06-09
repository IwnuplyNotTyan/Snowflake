# ✨ Nix dotfiles

> [!NOTE]
> README not finished

# ❄️ Install

> [!WARNING]
> Not tested on non x86-64 systems, non intel's and Nixos support dropped

## 🐙 HostName's

| Hostname | Arch | Desc | Status |
|----------|------|------|--------|
|Lira|Linux_x86-64|Basic system with docker & tailscale| ❌ |
|Eweless3|Linux_x86-64|Built for nixos| ❌ |
|Anewaqq|Linux_x86-64|Home manager settings| ✅ |
|Anewaqq@darwin|Darwin_x86-64|HM mac version| ✅ |
|nod|Aarch64-linux|HM termux verson, broken | ❌* |

`*` - Commented

### 🍏 For Darwin_x86-64
```sh
NIXPKGS_ALLOW_BROKEN=1 nix build .#homeConfigurations.anewaqq@darwin.activationPackage --impure
```

### 🏳️‍⚧️ For Linux_x86-64
```sh
nix build .#homeConfigurations.anewaqq.activationPackage
```
