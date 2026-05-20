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

echo "Configuring niri services and portal settings..."
sudo -u "${USERNAME}" systemctl --user add-wants niri.service dms

echo "Configuring plasma-polkit-agent override..."
sudo -u "${USERNAME}" mkdir -p "/home/${USERNAME}/.config/systemd/user/plasma-polkit-agent.service.d"
sudo -u "${USERNAME}" bash -c "cat <<EOF > '/home/${USERNAME}/.config/systemd/user/plasma-polkit-agent.service.d/override.conf'
[Unit]
After=graphical-session.target
EOF"
