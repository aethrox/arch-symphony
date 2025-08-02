#!/usr/bin/env bash
# post-install.sh - Arch Symphony Full Post-Install Script
# Usage: arch-chroot /mnt /tmp/post-install.sh

set -euo pipefail

# Logging setup
LOGFILE="/var/log/arch-symphony-postinstall.log"
mkdir -p "$(dirname "$LOGFILE")"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[INFO] Starting Arch Symphony post-install tasks"

# 1. Create swap file
echo "[STEP 1] Creating swap file"
fallocate -l 4G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=4096
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

echo "[STEP 1] Swap file created"

# 2. Update mirrorlist and enable parallel downloads
echo "[STEP 2] Optimizing mirrors and pacman parallel downloads"
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/^#ParallelDownloads =/ParallelDownloads =/' /etc/pacman.conf

echo "[STEP 2] Mirrorlist updated and parallel downloads enabled"

# 3. Ensure git and base-devel are installed
echo "[STEP 3] Ensuring development tools"
pacman -Sy --noconfirm --needed git base-devel

echo "[STEP 3] Development tools installed"

# 4. Install official repository packages
echo "[STEP 4] Installing official repository packages"
OFFICIAL_PKGS=(
  nano btop thunderbird bitwarden libreoffice vlc croc iptables ufw
  glow jq ranger translate-shell mosh ncdu imagemagick pandoc
  gh speedtest-cli bat ripgrep duf
)
pacman -Sy --noconfirm --needed "${OFFICIAL_PKGS[@]}"

echo "[STEP 4] Official packages installed"

# 5. Install AUR packages using yay
echo "[STEP 5] Installing AUR packages"
AUR_PKGS=(
  octopi visual-studio-code-bin masterpdfeditor-free zen-browser
  taskbook typora
)
runuser -u aethrox -- bash -c 'yay -S --noconfirm --needed ${AUR_PKGS[@]}'

echo "[STEP 5] AUR packages installed"

# 6. Configure UFW firewall
echo "[STEP 6] Configuring UFW firewall"
pacman -Sy --noconfirm --needed ufw
ufw default deny incoming
ufw default allow outgoing
ufw enable

echo "[STEP 6] UFW firewall enabled"

# 7. Copy Zsh configuration files
echo "[STEP 7] Updating Zsh configuration"
runuser -u aethrox -- bash -c '
  cp /home/aethrox/arch-symphony/zsh/.zshrc /home/aethrox/.config/zsh/.zshrc && \
  cp /home/aethrox/arch-symphony/zsh/.p10k.zsh /home/aethrox/.config/zsh/.p10k.zsh && \
  chown -R aethrox:aethrox /home/aethrox/.config/zsh
'

echo "[STEP 7] Zsh configuration updated"

# 8. Copy Hyprland configuration file
echo "[STEP 8] Copying Hyprland configuration"
runuser -u aethrox -- bash -c '
  cp /home/aethrox/arch-symphony/config/keybindings.conf /home/aethrox/.config/hypr/keybindings.conf && \
  chown -R aethrox:aethrox /home/aethrox/.config/hypr
'

echo "[STEP 8] Hyprland configuration copied"

# 9. Disable root SSH login
echo "[STEP 9] Disabling root SSH login"
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "[STEP 9] Root SSH login disabled"

echo "[INFO] All post-install tasks completed successfully"
