alias ls="eza -A"
alias tree="eza --tree"
alias vi="nvim"
alias ll="yazi"
alias ..="cd .."
alias nc="cd ~/.config/nvim"
alias nixos="cd /etc/nixos"
alias np="cd ~/projects/nixos-config/"
alias nd="cd ~/.config/nix-darwin/"
alias vind="nvim ~/.config/nix-darwin/flake.nix"

alias vish="nvim ~/.zshrc"
alias scsh="source ~/zshrc"
alias va="source ~/.zshrc"

alias gc="git clone"

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

### mise
export MISE_SHELL=zsh
export __MISE_ORIG_PATH="$PATH"

mise() {
  local command
  command="${1:-}"
  if [ "$#" = 0 ]; then
    command /run/current-system/sw/bin/mise
    return
  fi
  shift

  case "$command" in
  deactivate|shell|sh)
    # if argv doesn't contains -h,--help
    if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
      eval "$(command /run/current-system/sw/bin/mise "$command" "$@")"
      return $?
    fi
    ;;
  esac
  command /run/current-system/sw/bin/mise "$command" "$@"
}

_mise_hook() {
  eval "$(/run/current-system/sw/bin/mise hook-env -s zsh)";
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_mise_hook]+1}" ]]; then
  precmd_functions=( _mise_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_mise_hook]+1}" ]]; then
  chpwd_functions=( _mise_hook ${chpwd_functions[@]} )
fi

_mise_hook
if [ -z "${_mise_cmd_not_found:-}" ]; then                                                             _mise_cmd_not_found=1
    [ -n "$(declare -f command_not_found_handler)" ] && eval "${$(declare -f command_not_found_handler)/command_not_found_handler/_command_not_found_handler}"

    function command_not_found_handler() {
        if /run/current-system/sw/bin/mise hook-not-found -s zsh -- "$1"; then
          _mise_hook
          "$@"
        elif [ -n "$(declare -f _command_not_found_handler)" ]; then
            _command_not_found_handler "$@"
        else
            echo "zsh: command not found: $1" >&2
            return 127
        fi
    }
fi

#zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi
