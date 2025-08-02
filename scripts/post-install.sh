#!/usr/bin/env bash
# post-install.sh - Arch Symphony Post-Install Script (English)
# Usage: arch-chroot /mnt /tmp/post-install.sh

set -euo pipefail

# Logging setup
LOGFILE="/var/log/arch-symphony-postinstall.log"
mkdir -p "$(dirname "$LOGFILE")"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[INFO] Starting Arch Symphony post-install script"

# 1. Install official repository packages
echo "[STEP 1] Installing official packages"
OFFICIAL_PKGS=(
  nano btop thunderbird bitwarden libreoffice vlc croc iptables ufw
  glow jq ranger translate-shell mosh ncdu imagemagick pandoc
  gh speedtest-cli bat ripgrep duf
)
pacman -Sy --noconfirm --needed "${OFFICIAL_PKGS[@]}"

# 2. Install AUR packages using yay
echo "[STEP 2] Installing AUR packages"
AUR_PKGS=(
  octopi visual-studio-code-bin masterpdfeditor-free zen-browser
  taskbook typora
)
runuser -u aethrox -- bash -c 'yay -S --noconfirm --needed ${AUR_PKGS[@]}'

# 3. Enable and configure UFW firewall
echo "[STEP 3] Configuring UFW firewall"
pacman -Sy --noconfirm --needed ufw
ufw default deny incoming
ufw default allow outgoing
ufw enable

# 4. Copy Zsh configuration files
echo "[STEP 4] Updating Zsh configuration"
runuser -u aethrox -- bash -c '
  mkdir -p /home/aethrox/.config/zsh && \
  cp /home/aethrox/arch-symphony/zsh/.zshrc /home/aethrox/.config/zsh/.zshrc && \
  cp /home/aethrox/arch-symphony/zsh/.p10k.zsh /home/aethrox/.config/zsh/.p10k.zsh && \
  chown -R aethrox:aethrox /home/aethrox/.config/zsh
'

# 5. Copy Hyprland configuration file
echo "[STEP 5] Copying Hyprland configuration"
runuser -u aethrox -- bash -c '
  mkdir -p /home/aethrox/.config/hypr && \
  cp /home/aethrox/arch-symphony/config/keybindings.conf /home/aethrox/.config/hypr/keybindings.conf && \
  chown -R aethrox:aethrox /home/aethrox/.config/hypr
'

echo "[INFO] Post-install tasks completed successfully"
