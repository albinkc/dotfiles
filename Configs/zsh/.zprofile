
eval "$(/opt/homebrew/bin/brew shellenv)"
# Ensure if needed in the future
export PATH=/Users/albin/.cargo/bin:$PATH

# IEx (and erl) shell history
export ERL_AFLAGS="-kernel shell_history enabled"

