alias ls="eza -A"
alias tree="eza --tree"
alias vi="nvim"
alias ll="yazi"
alias ..="cd .."
alias nc="cd ~/.config/nvim"
alias nixos="cd /etc/nixos"
alias np="cd ~/projects/nixos-config/"
alias nd="cd ~/.config/nix-darwin/"
alias vind="nvim /etc/nix-darwin/flake.nix"
alias drs="darwin-rebuild switch"

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
alias im="iex -S mix"
alias ims="iex -S mix phx.server"
alias ms="mix phx.server"
export ERL_AFLAGS="-kernel shell_history enabled"

export EDITOR=nvim
# Enable Vim mode in Zsh
bindkey -v
# Set keybindings for switching modes
bindkey '^R' history-incremental-search-backward  # Search history in normal mode
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
