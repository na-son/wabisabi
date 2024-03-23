# wabisabi

Goofing around with bare metal + nix.

## Usage


Build system (optional)

```shell
nix build .#nixosConfigurations.peace.config.system.build.toplevel
nix run .#build
```

Make configuration active

```shell
nixos-rebuild switch --flake .#peace
nix run .#build-switch
```

### Linux

Boot the [minimal installer](https://nixos.org/download)

THIS WILL WIPE YOUR DISKS AND APPLY THE PARTITION SCHEME IN
`./modules/nixos/disk-config.nix`

```shell
sudo nix run --extra-experimental-features 'nix-command flakes' github:na-son/wabisabi#install
```

After the initial install completes and you land at the greeter, hit `CTRL+ALT+F6` to open a terminal and login as root.

Set a password for your user, and configure things like keyboard layout and drivers in `/etc/nixos/hosts/nixos/default.nix`.

```shell
passwd $user
logout
# login as $user
cd /etc/nixos
# make changes to the system config if necessary
sudo vim hosts/nixos/default.nix
nix run .#build-switch
```

To test changes you can also run:

```shell
nixos-rebuild build --flake .#peace
```
