# Deploy

### Step0. 烧录 UEFI

1. 进入 MaskRom.
2. 打开 RKDevTool_v3.15_for_window
    + 第一行存储为空，地址为 0 ，路径选择 MiniLoaderAll.bin
    + 第二行存储为SPINOR，地址为 0 ，路径选择 UEFI固件 [edk2-rk3588](https://github.com/edk2-porting/edk2-rk3588)


Flakes for rk3588 boards
+ orangepi5plus-webapp

### Example for orangepi5plus-webapp

```bash
# switch to root
sudo su

export https_proxy=http://10.5.1.130:7890 http_proxy=http://10.5.1.130:7890 all_proxy=socks5://10.5.1.130:7890

# clone this repo
git clone https://github.com/Philogag/nixos-rk3588-deploy

# format disk and mount by disko
nix run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/orangepi5plus-webapp/disko-config.nix

# install nixos into disk
nixos-install --root /mnt --flake .#orangepi5plus-webapp --no-root-password --show-trace --verbose

cp ../nixos-rk3588-deploy /mnt/etc/nixos
```
