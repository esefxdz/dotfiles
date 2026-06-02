#!/usr/bin/env bash
# ============================================================
# esef's dotfiles — install.sh
# Acer Nitro AN515-51 | Arch Linux | Hyprland + Caelestia
# ============================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()    { echo -e "${CYAN}${BOLD}==> $1${NC}"; }
success() { echo -e "${GREEN}  ✓ $1${NC}"; }
warn()    { echo -e "${YELLOW}  ⚠ $1${NC}"; }
error()   { echo -e "${RED}  ✗ $1${NC}"; exit 1; }

echo -e "${BOLD}"
echo "  ┌─────────────────────────────────────────┐"
echo "  │         esef's dotfiles installer        │"
echo "  │   Arch Linux · Hyprland · Caelestia      │"
echo "  └─────────────────────────────────────────┘"
echo -e "${NC}"

[[ "$(uname -s)" != "Linux" ]] && error "This script only runs on Linux."
[[ ! -f /etc/arch-release ]] && warn "Not detected as Arch Linux. Proceed with caution."

# ── Step 1: AUR helper ──────────────────────────────────────
info "Checking for AUR helper..."
if ! command -v paru &>/dev/null && ! command -v yay &>/dev/null; then
    info "Installing paru..."
    sudo pacman -S --needed git base-devel
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmp/paru"
    (cd "$tmp/paru" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    success "paru installed"
else
    success "AUR helper already present"
fi
AUR_HELPER=$(command -v paru || command -v yay)

# ── Step 2: Packages ────────────────────────────────────────
info "Installing packages from packages.txt..."
grep -v '^\s*#' "$DOTFILES_DIR/packages.txt" | grep -v '^\s*$' \
    | $AUR_HELPER -S --needed --noconfirm -
success "Packages installed"

# ── Step 3: Default shell ───────────────────────────────────
info "Setting zsh as default shell..."
if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" && success "Default shell set to zsh"
else
    success "zsh is already the default shell"
fi

# ── Step 4: Symlinks ────────────────────────────────────────
info "Creating symlinks..."

link() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    # Remove old broken/different symlink or backup real file/dir
    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ ! -L "$dest" ]]; then
            mv "$dest" "${dest}.bak.$(date +%s)" && warn "Backed up: $dest"
        elif [[ "$(readlink "$dest")" != "$src" ]]; then
            rm -rf "$dest"
        fi
    fi
    ln -sfn "$src" "$dest"
    success "$(basename "$dest") → $src"
}

# Shell
link ".zshrc"                           "$HOME/.zshrc"

# Hyprland
link ".config/hypr/hyprland.conf"       "$HOME/.config/hypr/hyprland.conf"
link ".config/hypr/hyprlock.conf"       "$HOME/.config/hypr/hyprlock.conf"
link ".config/hypr/hypridle.conf"       "$HOME/.config/hypr/hypridle.conf"

# Terminal
link ".config/kitty"                    "$HOME/.config/kitty"

# Launchers
link ".config/fuzzel"                   "$HOME/.config/fuzzel"
link ".config/rofi"                     "$HOME/.config/rofi"

# System monitor / fetch
link ".config/btop"                     "$HOME/.config/btop"
link ".config/fastfetch"                "$HOME/.config/fastfetch"

# Shell prompt
link ".config/starship.toml"            "$HOME/.config/starship.toml"

# ── Step 5: Wallpapers ──────────────────────────────────────
info "Installing wallpapers..."
mkdir -p "$HOME/wallpapers"
cp -rn "$DOTFILES_DIR/wallpapers/"* "$HOME/wallpapers/" 2>/dev/null || true
success "Wallpapers installed to ~/wallpapers/"

# ── Step 6: Services ────────────────────────────────────────
info "Enabling system services..."
sudo systemctl enable NetworkManager 2>/dev/null && success "NetworkManager enabled" || warn "Already enabled"
sudo systemctl enable ly            2>/dev/null && success "ly enabled"            || warn "Already enabled"

echo ""
echo -e "${GREEN}${BOLD}Done! Reboot and select Hyprland at the ly login screen.${NC}"
echo -e "${CYAN}After first login, run:${NC}"
echo -e "${CYAN}  caelestia scheme set -n shadotheme${NC}"
echo -e "${CYAN}  caelestia wallpaper -f ~/wallpapers/wallpaper.png${NC}"
