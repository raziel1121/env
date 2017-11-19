#!/bin/bash

basedir=$(pwd)

ENV=$1    # personal,wyzant

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    brew install $1
  fi
}

### GENERAL ###
echo "Installing Homebrew and some basic things......"
[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
install 'wget'
install 'ack'
install 'tmux'
install 'ctags'
install 'the_silver_searcher'

echo "source $basedir/aliases" > ~/.aliases
echo "source $basedir/osx/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/gitconfig
EOF
if [ -n "$ENV" ] && [[ -r $basedir/gitconfig.$ENV ]]; then
  cat >> ~/.gitconfig << EOF
  path = $basedir/gitconfig.$ENV
EOF
fi
ln -sf $basedir/.gitignore_global ~/
install 'hub'

### Install git submodules - typically plugins for vim and tmux
git submodule init
git submodule update

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/.vim ~/

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/.tmux ~/
ln -sf $basedir/.tmux.conf ~/
tmux source ~/.tmux.conf

### MISC ###
echo "Linking bin directory......"
ln -sf $basedir/bin ~/

### ZSH ###
echo "Installing and switching to ZSH......"
install 'zsh'
chsh -s `which zsh`
curl -L git.io/antigen > ~/antigen.zsh
echo "source $basedir/zshrc" > ~/.zshrc
echo "source $basedir/env" >> ~/.zshrc
/bin/zsh -i -c "source ~/antigen.zsh"

echo "OSX Setup complete!"
