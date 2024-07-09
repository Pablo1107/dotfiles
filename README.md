# Arch Linux + Nix config

## TODO: bootstrap Arch Linux install

## Bootstrap Home Manager
```
nix run --no-write-lock-file github:nix-community/home-manager/ -- --flake ".#$USER" switch
```

## Run this command
```
home-manager switch --flake .
```

# Nix Darwin config

![Nix Darwin Screenshot](./screenshots/nix-darwin-screenshot.png)

## Run this command
```
nix shell nixpkgs\#git
nix clone https://github.com/Pablo1107/dotfiles
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
darwin-rebuild switch --flake .
```

# Nix on Android config

![Nix on Droid Screenshot](./screenshots/nix-on-droid-screenshot.jpg)

## First install
```
nix --extra-experimental-features nix-command shell --extra-experimental-features flakes nixpkgs#git
ssh-keygen
git clone https://github.com/Pablo1107/dotfiles
```

## Run this command
```
nix-on-droid switch --flake ".#sm-g950f"
```

# NixOS on RPi
```
sudo pacman -S qemu-user-static qemu-user-static-binfmt
```

```
nix build .#nixosConfigurations.rpi.config.system.build.sdImage
```

```
rm -rf run-rpi-vm && cp result/bin/run-rpi-vm . && sed -i "s/[^ ]*qemu-host-cpu-only[^ ]*/$(which qemu-system-aarch64 | sed 's/\//\\\//g')/" run-rpi-vm && ./run-rpi-vm -serial stdio
```

# NixOS on Server

```
nixos-rebuild switch --flake .#server --target-host "root@nixos.local"
```

# Nix Template
```
nix flake init -t ~/dotfiles\#template
```

# Some known issues
## unsupported tarball input

```
       error: unsupported tarball input attribute 'lastModified'
```

### Solution:
```sh
jq '.nodes |= map_values(if .locked.type? == "tarball" then .locked |= del(.lastModified) else . end)' flake.lock > flake.lock.new
```

[source](https://www.reddit.com/r/NixOS/comments/175w44g/comment/k4r8bzi/?utm_source=reddit&utm_medium=web2x&context=3)

## Nix 17 vs Nix 18
https://github.com/nix-community/home-manager/issues/4692
