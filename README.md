# 🎶 arch-symphony 🎶

> **Automated Arch Linux Orchestration**
>
> Bring precision and harmony to your Arch Linux install with a tunable `archinstall` profile and modular post-install scripts.

---

## 🚀 Quickstart

### Initial Installation

1. **Connect to the Internet** (in the live environment)
   ```bash
   nmcli device wifi connect "SSID_NAME" password "PASSWORD"
   ```
2. **Fetch the `arch-symphony.json` Profile**
   ```bash
   curl -o /tmp/arch-symphony.json \
     https://raw.githubusercontent.com/aethrox/arch-symphony/main/arch-symphony.json
   ```
3. **Run the Automated Installer**
   ```bash
   archinstall --config /tmp/arch-symphony.json
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

## 🛠️ Customize

- **Profile**: Tweak `config/profile.json` (hostname, disks, packages)
- **Scripts**: Extend `scripts/post-install.sh` with your own tasks
- **Kernels**: Swap in `linux-lts`, `linux-hardened`, or others

---

## 🤝 Contribute

Pull requests and issues welcome! Ideas:

- New post-install modules
- Security hardening
- Additional kernel or service profiles

Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## 📜 License

MIT © Your Name
