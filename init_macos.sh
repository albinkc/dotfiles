# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install mise
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

source ~/.zshrc
mise use -g rust@latest

cargo install --git https://github.com/RaphGL/Tuckr.git
rm ~/.zshrc
rm ~/.zprofile
tuckr add \*
source ~/.zshrc
source ~/.zprofile

# install determinate-nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

sudo mkdir -p /etc/nix-darwin
sudo cp $HOME/Configs/nix-darwin/.config/nix-darwin/flake.nix /etc/nix-darwin/
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin

# To use Nixpkgs unstable:
nix run nix-darwin/master#darwin-rebuild -- switch
cd /etc/nix-darwin
