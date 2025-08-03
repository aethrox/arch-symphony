#!/usr/bin/env bash
# post_install.sh - Arch Symphony Full Post-Install Script
# Usage: ./post_install.sh

set -euo pipefail

# Logging setup
LOGFILE="/var/log/arch-symphony-postinstall.log"
mkdir -p "$(dirname "$LOGFILE")"
exec > >(tee -a "$LOGFILE") 2>&1

echo "[INFO] Starting Arch Symphony post-install tasks"

# 1. Update mirrorlist and enable parallel downloads
echo "[STEP 1] Optimizing mirrors and pacman parallel downloads"
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/^#ParallelDownloads =/ParallelDownloads =/' /etc/pacman.conf

echo "[STEP 1] Mirrorlist updated and parallel downloads enabled"

# 2. Ensure git and base-devel are installed
echo "[STEP 2] Ensuring development tools"
pacman -Sy --noconfirm --needed git base-devel

echo "[STEP 2] Development tools installed"

# 3. Configure UFW firewall
echo "[STEP 3] Configuring UFW firewall"
pacman -Sy --noconfirm --needed ufw
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

echo "[STEP 3] UFW firewall enabled"

# 4. Disable root SSH login
echo "[STEP 4] Disabling root SSH login"
sed -i 's/^#\s*ParallelDownloads\s*=.*/ParallelDownloads = 5/' /etc/pacman.conf
systemctl restart sshd

echo "[STEP 4] Root SSH login disabled"

# 5. Fetch and copy Zsh configuration files
echo "[STEP 5] Downloading and updating Zsh configuration"
runuser -u aethrox -- bash -c '
  curl --fail --location \
    https://raw.githubusercontent.com/aethrox/arch-symphony/main/scripts/zsh/.zshrc \
    -o /home/aethrox/.config/zsh/.zshrc && \
  curl --fail --location \
    https://raw.githubusercontent.com/aethrox/arch-symphony/main/scripts/zsh/.p10k.zsh \
    -o /home/aethrox/.config/zsh/.p10k.zsh && \
  chown -R aethrox:aethrox /home/aethrox/.config/zsh
'
echo "[STEP 5] Zsh configuration updated"

# 6. Fetch and copy Hyprland configuration files
echo "[STEP 6] Downloading and copying Hyprland configuration"
runuser -u aethrox -- bash -c '
  curl --fail --location \
    https://raw.githubusercontent.com/aethrox/arch-symphony/main/config/keybindings.conf \
    -o /home/aethrox/.config/hypr/keybindings.conf && \
  curl --fail --location \
    https://raw.githubusercontent.com/aethrox/arch-symphony/main/config/userprefs.conf \
    -o /home/aethrox/.config/hypr/userprefs.conf && \
  chown -R aethrox:aethrox /home/aethrox/.config/hypr
'
echo "[STEP 6] Hyprland configuration fetched and copied"

# 7. Install official repository packages
echo "[STEP 7] Installing official repository packages"
OFFICIAL_PKGS=(
  nano btop thunderbird bitwarden libreoffice vlc croc iptables ufw
  glow jq ranger translate-shell mosh ncdu imagemagick pandoc
  gh speedtest-cli bat ripgrep duf
)
sudo pacman -S --noconfirm --needed "${OFFICIAL_PKGS[@]}"

echo "[STEP 7] Official packages installed"

# 8. Install AUR packages using yay
echo "[STEP 8] Installing AUR packages"

AUR_USER="${1:-aethrox}"  # default kullanıcı aethrox

AUR_PKGS=(
  octopi visual-studio-code-bin masterpdfeditor-free zen-browser
  taskbook typora
)

YAY_OPTS=(
  --noconfirm    # onay sorusunu atla
  --needed       # zaten kuruluysa geç
  --nodiffmenu   # değişiklik diff menüsünü atla
  --nocleanmenu  # temizleme onayını atla
)

runuser -u "$AUR_USER" -- bash -lc "yay -S ${YAY_OPTS[*]} ${AUR_PKGS[*]}" 

echo "[STEP 8] AUR packages installed"

echo "[INFO] All post-install tasks completed successfully"
