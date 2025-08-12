t() {
  [ $# -eq 0 ] && { echo "usage: t <path>"; return 1; }
  mkdir -p -- "$(dirname -- "$1")" && touch -- "$1"
}

bid () {
  local app="$*"
  [[ -z $app ]] && { echo "usage: bid <Application Name>"; return 1; }
  osascript -e "id of app \"$app\""
}

alias p1="ping 1.1.1.1"
alias touch="t"
alias ls="eza -A"
alias n="nnn"
alias tree="eza --tree"
alias vi="nvim"
alias ll="yazi"
alias ..="cd .."
alias nc="cd ~/.config/nvim"
alias nixos="cd /etc/nixos"
alias np="cd ~/projects/nixos-config/"
alias nd="cd ~/.config/nix-darwin/"
alias vind="nvim /etc/nix-darwin/flake.nix"
alias drs="sudo darwin-rebuild switch"
alias gi="git init && git add . && git commit -m \"initial commit\""

alias zp="zed-preview"

alias vish="nvim ~/.zshrc"
alias scsh="source ~/.zshrc"
alias va="source ~/.zshrc"

alias gc="git clone"
alias lg="lazygit"

# alias ja="just --working-directory ~/.config/nix-darwin apply"
alias ja="just --justfile ~/.config/nix-darwin/justfile \
             --working-directory ~/.config/nix-darwin \
             apply"

#Elixir
alias im="source .env && iex -S mix"
alias ims="source .env && iex -S mix phx.server"
alias ms="source .env && mix phx.server"
export ERL_AFLAGS="-kernel shell_history enabled"
## Run after elixir otp upgrades or when elixir-ls is broken
alias clean_beam='rm -rf _build deps .elixir_ls && mix deps.get && mix compile'

export EDITOR=neovide
# Enable Vim mode in Zsh
bindkey -v
# Set keybindings for switching modes
bindkey '^R' history-incremental-search-backward  # Search history in normal mode
# option + delete = delete word
bindkey -M viins $'\e\x7f' backward-kill-word

# mise
eval "$(mise activate zsh)"

#zsh-completions
# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#   autoload -Uz compinit
#   compinit
# fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/albin/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Secretive Config
export SSH_AUTH_SOCK=/Users/albin/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Add Elixir mix escripts to PATH
export PATH="/Users/albin/.mix/escripts:$PATH"
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# opencode
export PATH=/Users/albin/.opencode/bin:$PATH
export PATH=/Users/albin/.local/bin:$PATH

