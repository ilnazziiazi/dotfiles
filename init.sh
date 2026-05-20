#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===> Starting Dotfiles Initialization <===${NC}"
OS_TYPE=$(uname -s)

setup_macos() {
  echo -e "${GREEN}Detected macOS. Running Homebrew pipeline...${NC}"

  # homebrew
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew bundle --file=~/dotfiles/brew/Brewfile

  # stow
  stow -f ghostty git nvim p10k task tmux zsh
}

setup_linux() {
  echo -e "${GREEN}Detected Linux. Running Source/Apt pipeline...${NC}"

  # warmup
  echo "Please authenticate to install system components:"
  sudo -v
  sudo apt update

  # installing from packages file
  PACKAGES_FILE="$HOME/dotfiles/apt/packages.txt"
  grep -v '^#' "$PACKAGES_FILE" | xargs sudo apt install -y

  # stow
  stow -f nvim p10k tmux zsh

  # nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

  # docker
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
}

setup_common() {
  echo -e "${GREEN}Running common setup (Zsh, OMZ, Stow)...${NC}"

  # omz
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # omz plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] &&
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] &&
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] &&
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
}

# start pipelines
setup_common
if [ "$OS_TYPE" == "Darwin" ]; then
  setup_macos
elif [ "$OS_TYPE" == "Linux" ]; then
  setup_linux
fi
echo -e "${BLUE}===> Initialization Complete! Restart your shell. <===${NC}"
