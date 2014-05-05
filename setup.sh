#!/usr/bin/env bash

# some tools will complain about not knowing where binaries are, until you do this:
echo "Making sure you have XCode command line tools..."
sudo xcode-select --install

# set up a basic .profile
if ! [ -a ~/.profile ]; then
  cat <<EOF > ~/.profile
export PATH="/usr/local/bin:\$PATH" # homebrew
export PATH="./node_modules/.bin:\$PATH" # locally installed node binaries
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
source \$(brew --prefix nvm)/nvm.sh

# for passwords and stuff:
if [ -f ~/.sekret ]; then
  source ~/.sekret
fi

EOF
fi

# install homebrew
if ! which -s brew; then
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
fi
brew doctor

# install important brew packages
brew install wget git qt

# install homebrew cask and some mac os apps
brew tap phinze/homebrew-cask
brew install brew-cask
brew cask install google-chrome firefox google-hangouts

# configure git
echo "Configuring git settings:"
gitusername=$(git config --global user.name)
gituseremail=$(git config --global user.email)
read -t 0.1 -n 10000 # flush input from stdin
read -p "What name should go on your commits? " -ei $gitusername gitusername
read -p "What is your git email address? " -ei $gituseremail gituseremail
git config --global push.default simple
git config --global user.name $gitusername
git config --global user.email $gituseremail
git config --global credential.helper osxkeychain

# install nvm and node
source ~/.profile
nvm install v0.10.26
nvm alias default v0.10.26

# global node modules
npm install --global grunt-cli coffee-script

# projects directory
mkdir ~/Projects

# increase maximum number of open files
echo "Increasing number of maximum open files to a very high number, so node is happy..."
sudo sh -c 'echo "limit maxfiles 1000000 1000000" >> /etc/launchd.conf'

# Newsbound stuff
#=================

# heroku
brew install heroku

# mongo
brew install mongodb
ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents # load on startup
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist # run now

# integration test tools
brew install phantomjs selenium-server-standalone chromedriver

# we're done!
echo "Done setting up your developer laptop! Now feel free to make it your own."
echo "We recommend restarting your machine at this point."

