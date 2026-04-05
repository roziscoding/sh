#!/bin/bash
set -e

if [ -f /etc/arch-release ]; then
  echo "==> Arch Linux detected"
else
  echo "OS not supported"
  exit 1
fi

# --- Check phase ---

need_yay=false
need_mise=false
need_chezmoi=false
need_op=false
need_1password=false
need_auth=false
need_init=false

echo "==> Checking what needs to be done..."

if ! command -v yay &>/dev/null; then
  echo "  - yay: not installed"
  need_yay=true
else
  echo "  - yay: ok"
fi

if ! command -v mise &>/dev/null; then
  echo "  - mise: not installed"
  need_mise=true
else
  echo "  - mise: ok"
fi

if ! command -v chezmoi &>/dev/null; then
  echo "  - chezmoi: not installed"
  need_chezmoi=true
else
  echo "  - chezmoi: ok"
fi

if ! command -v op &>/dev/null; then
  echo "  - 1Password CLI: not installed"
  need_op=true
else
  echo "  - 1Password CLI: ok"
fi

if ! pacman -Qi 1password &>/dev/null; then
  echo "  - 1Password desktop: not installed"
  need_1password=true
else
  echo "  - 1Password desktop: ok"
fi

if op account list &>/dev/null && [ "$(op account list 2>/dev/null)" != "" ]; then
  echo "  - 1Password auth: ok"
else
  echo "  - 1Password auth: not authenticated"
  need_auth=true
fi

if [ -d "$HOME/.local/share/chezmoi" ]; then
  echo "  - chezmoi init: ok"
else
  echo "  - chezmoi init: not initialized"
  need_init=true
fi

if ! $need_yay && ! $need_mise && ! $need_chezmoi && ! $need_op && ! $need_1password && ! $need_auth && ! $need_init; then
  echo ""
  echo "You're all set up, nothing to do here!"
  exit 0
fi

# --- Confirm ---

echo ""
read -p "Proceed with setup? [y/N] " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
  echo "Aborted."
  exit 0
fi

# --- Act phase ---

echo ""

if $need_yay; then
  echo "==> Installing yay..."
  if pacman -Si yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm yay
  else
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    cd "$tmpdir/yay-bin"
    makepkg -si --noconfirm
    cd -
    rm -rf "$tmpdir"
  fi
fi

if $need_mise; then
  echo "==> Installing mise..."
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if $need_chezmoi; then
  echo "==> Installing chezmoi via mise..."
  mise use -g chezmoi
fi

if $need_op; then
  echo "==> Installing 1Password CLI via mise..."
  mise use -g 1password-cli
fi

if $need_1password; then
  echo "==> Installing 1Password desktop..."
  yay -S --needed --noconfirm 1password
fi

if $need_auth; then
  echo "==> Opening 1Password..."
  1password &
  echo ""
  echo "Please sign in to 1Password, then press any key to continue..."
  read -n 1 -s -r

  echo "==> Verifying 1Password CLI authentication..."
  if op account list &>/dev/null && [ "$(op account list 2>/dev/null)" != "" ]; then
    echo "==> 1Password CLI authenticated successfully"
  else
    echo "ERROR: 1Password CLI is not authenticated. Please sign in and try again."
    exit 1
  fi
fi

if $need_init; then
  echo "==> Initializing chezmoi..."
  chezmoi init roziscoding
fi

echo ""
echo "==> Done!"
