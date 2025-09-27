# Deploy

Flakes for rk3588 boards
+ orangepi5plus-webapp

### Example for orangepi5plus-webapp

```bash
# switch to root
sudo su

export https_proxy=http://10.5.1.130:7890 http_proxy=http://10.5.1.130:7890 all_proxy=socks5://10.5.1.130:7890

# clone this repo

# format disk and mount by disko
nix run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/orangepi5plus-webapp/disko-config.nix

# install nixos into disk
nixos-install --root /mnt --flake .#orangepi5plus-webapp --no-root-password --show-trace --verbose
```
