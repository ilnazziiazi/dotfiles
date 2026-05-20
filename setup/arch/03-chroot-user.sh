#!/bin/bash
set -e

if [ -f "/config.env" ]; then
  source /config.env
else
  source "$(dirname "$0")/config.env"
fi

echo "Stowing dotfiles..."
cd "/home/${USERNAME}/dotfiles"
sudo -u "${USERNAME}" stow -f ghostty git nvim p10k tmux zsh niri waybar fuzzel mako
