#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/roman-xo/dot-files.git"

echo ":: Updating Arch ..."
sudo pacman -Syu --noconfirm

echo ":: Installing Dependencies ..."
sudo pacman -S --needed --noconfirm \
  bspwm sxhkd polybar rofi dunst libnotify nitrogen picom feh \
  kitty zsh \
  xorg xorg-xinit networkmanager sddm \
  noto-fonts noto-fonts-cjk noto-fonts-emoji \
  ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono \
  git curl unzip wget brightnessctl pamixer playerctl bc \
  ffmpeg dolphin npm \
  yazi python-pywal

echo ":: Installing yay AUR helper ..."
if ! command -v yay &> /dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
fi


  yay -S --noconfirm neofetch

echo ":: Cloning dots ..."
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

mkdir -p "$HOME/.config"
cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
[ -f "$DOTFILES_DIR/.xinitrc" ] && ln -sf "$DOTFILES_DIR/.xinitrc" "$HOME/.xinitrc"

echo ":: Installing terminal font ..."
mkdir -p "$HOME/.local/share/fonts"
cp -r "$DOTFILES_DIR/fonts/"* "$HOME/.local/share/fonts/" 2>/dev/null || true
fc-cache -fv

# Makes script files executable
chmod +x "$HOME/.config/sxhkd/sxhkdrc"
chmod +x "$HOME/.config/bspwm/bspwmrc"
chmod +x "$HOME/.config/bspwm/scripts/brightness.sh"
chmod +x "$HOME/.config/bspwm/scripts/media.sh"
chmod +x "$HOME/.config/bspwm/scripts/volume.sh"
chmod +x "$HOME/.config/rofi/launchers/type-6/launcher.sh"

echo ":: Setting up yummy colors ..."
mkdir -p "$HOME/wallpapers"
cp -r "$DOTFILES_DIR/wallpapers/"* "$HOME/wallpapers/"
wal -i "$HOME/wallpapers/default.jpg"

echo ":: Installing oh-my-zsh (unattended)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo ":: Configuring shell ..."
rm -f "$HOME/.zshrc"
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

chsh -s "$(which zsh)"

echo ":: Setting default wallpaper ..."
mkdir -p "$HOME/.config/nitrogen"
cat <<EOF > "$HOME/.config/nitrogen/bg-saved.cfg"
[xin_-1]
file=$HOME/wallpapers/default.jpg
mode=0
bgcolor=#000000
EOF

cat <<EOF > "$HOME/.config/nitrogen/nitrogen.cfg"
[geometry]
posx=0
posy=0
sizex=400
sizey=300

[saved]
file1=$HOME/wallpapers/default.jpg
EOF

  sudo systemctl enable --now sddm
  sudo systemctl enable --now NetworkManager

read -rp "↪ Install was successful! Would you like to reboot now? (Recommended) (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  reboot
else
  echo "Reboot skipped. You can reboot manually later."
fi
