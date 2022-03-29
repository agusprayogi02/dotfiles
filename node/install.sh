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

npm i -g add-gitignore
npm i -g lite-server
npm i -g surge
npm i -g share-cli
npm i -g prettier
npm i -g eslint
npm i -g nodemon
# npm i --g brightness-cli

nvm install node

echo_done "Node configuration!"
