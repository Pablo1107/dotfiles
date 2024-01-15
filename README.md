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
