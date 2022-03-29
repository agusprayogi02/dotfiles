#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring Node..."
echo_info "Installing nvm..."
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -

echo_info "Installing Node.js..."
sudo apt-get install -y nodejs

sudo npm i -g add-gitignore
sudo npm i -g lite-server
sudo npm i -g surge
sudo npm i -g share-cli
sudo npm i -g prettier
sudo npm i -g eslint
sudo npm i -g nodemon
# npm i --g brightness-cli

# nvm install node

echo_done "Node configuration!"
