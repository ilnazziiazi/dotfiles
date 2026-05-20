# PLACE ONLY AT THE BEGINNING
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# FUNCTIONS 
zsh-defer() {
  eval "$@"
}

add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}


# PATHS
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"


# ENVs
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"


# ALIASES
alias ll="ls -lah"
alias gs="git status"
alias gc="git commit"
alias gl="git pull"
alias v="XDG_CONFIG_HOME=$HOME/.config/lazyvim nvim"


# BINDs
bindkey '^R' fzf-history-widget


## FZF
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# OH-MY-ZSH
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode reminder

plugins=(
    git 
    zsh-autosuggestions 
    zsh-syntax-highlighting
    tmux
    colored-man-pages
    extract
)

source "$ZSH/oh-my-zsh.sh"


# HISTORY
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt hist_ignore_dups


#################################################################################################


OS_TYPE=$(uname -s)
if [[ "$OS_TYPE" == "Darwin" ]]; then

  # FUNCTIONS
  yt() {
    if [ -z "$1" ]; then 
      echo "Usage: yt <URL>"
      return 1
    fi
    yt-dlp \
      --cookies-from-browser safari \
      --sponsorblock-remove all \
      -o "~/Downloads/Youtube/%(upload_date)s - %(title)s.%(ext)s" \
      "$1"
  }

  ssh() {
    local terminfo_path="/Applications/Ghostty.app/Contents/Resources/terminfo/g/xterm-ghostty"
    if [[ ( "$TERM" == "xterm-ghostty" || "$TERMINFO" == *"Ghostty"* ) && -f "$terminfo_path" ]]; then
      /usr/bin/ssh "$@" "mkdir -p ~/.terminfo/g/ && [ ! -f ~/.terminfo/g/xterm-ghostty ]" && \
        scp -q "$terminfo_path" "${@[-1]}:~/.terminfo/g/xterm-ghostty"
    fi
    /usr/bin/ssh "$@"
  }


  # PATHs
  add_to_path "/opt/homebrew/bin:/opt/homebrew/sbin"
  add_to_path "$HOME/.lmstudio/bin" 
  add_to_path "/opt/homebrew/opt/node@24/bin"


  # ENVs
  export HOMEBREW_NO_ENV_HINTS=1


  # ALIASES
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"


elif [[ "$OS_TYPE" == "Linux" ]]; then
  # FUNCTIONS


  # PATHs
  add_to_path "/opt/nvim-linux-x86_64/bin"
fi


# PLACE ONLY IN THE END 
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"
