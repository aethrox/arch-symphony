# 🎶 arch-symphony 🎶

> **Automated Arch Linux Orchestration**
>
> Bring precision and harmony to your Arch Linux install with a tunable `archinstall` profile and modular post-install scripts.

---

## 🚀 Quickstart

1. **Connect to Wi-Fi**
   ```bash
   nmcli device wifi connect "SSID_NAME" password "PASSWORD"
   ```
2. **Clone**
   ```bash
   git clone https://github.com/aethrox/arch-symphony.git
   cd arch-symphony
   ```
3. **Fetch Config & Scripts**
   ```bash
   wget -O /tmp/profile.json \
     https://raw.githubusercontent.com/aethrox/arch-symphony/main/config/profile.json
   wget -O /tmp/post-install.sh \
     https://raw.githubusercontent.com/aethrox/arch-symphony/main/scripts/post-install.sh
   chmod +x /tmp/post-install.sh
   ```
4. **Install & Bootstrap**
   ```bash
   archinstall --config /tmp/profile.json
   arch-chroot /mnt /tmp/post-install.sh
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
