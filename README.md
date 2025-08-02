# 🎶 arch-symphony 🎶

> **Automated Arch Linux Orchestration**
>
> Bring precision and harmony to your Arch Linux install with a tunable `archinstall` profile and modular post-install scripts.

---

## 🚀 Quickstart

### Initial Installation

1. **Connect to the Internet** (in the live environment)
   ```
   iwctl device list
   iwctl station DEVICE scan
   iwctl station DEVICE get-networks
   iwctl --passphrase=PASSPHRASE station DEVICE connect SSID
   ```
3. **Fetch the `arch-symphony.json` Profile**
   ```bash
   cd /tmp
   curl -O https://raw.githubusercontent.com/aethrox/arch-symphony/main/{user_configuration,user_credentials}.json
   ```
4. **Run the Automated Installer**
   ```bash
   archinstall --config user_configuration.json --creds user_credentials.json
   ```

---

### Post-Installation

4. **Fetch & Execute the Post-Install Script**
   ```bash
   curl -o /tmp/post-install.sh \
     https://raw.githubusercontent.com/aethrox/arch-symphony/main/scripts/post-install.sh
   
   chmod +x /tmp/post-install.sh
   
   arch-chroot /mnt /tmp/post-install.sh
   ```
5. **Reboot into Your New System**
   ```bash
   reboot
   ```

---

## 🔧 Features

- **Disk & FS**: Predefined ext4 partitions
- **User & Security**: Strong passwords, disable root SSH
- **Kernels**: Install `linux` + `linux-zen`
- **Performance**: Fast mirror selection + parallel downloads
- **Swapfile**: 4 GB reserved swap
- **AUR Helper**: Bootstraps `yay`

---

## 📜 License

MIT © Your Name
