# ✨ Nix dotfiles

> [!NOTE]
> README not finished

# ❄️ Install

> [!WARNING]
> Not tested in non x86_64 system's and non intel hardware

## 🍏 For Darwin_x86-64
```sh
NIXPKGS_ALLOW_BROKEN=1 nix build .#homeConfigurations.anewaqq@darwin.activationPackage --impure
```

## 🏳️‍⚧️ For Linux_x86-64
```sh
nix build .#homeConfigurations.anewaqq.activationPackage
```
