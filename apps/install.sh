#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Installing All pkgs..."

PKGS=(
  code # vscode for linux
  sublime-merge # Sublime Merge
  sublime-text # Sublime Text
)

echo_info "Patching packages..."
sudo apt-get install curl wget ca-certificates gnupg lsb-release apt-transport-https

# vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Add the tangram gpg key. Ubuntu 20.04
curl -fsSL https://pkgs.tangram.dev/stable/ubuntu/focal.gpg | sudo apt-key add -

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Kubernetes
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

echo_info "Installing Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo_info "trying Docker running..."
sudo docker run hello-world

echo_info "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo_info "Installing kubernetes..."
sudo apt-get install -y kubectl

echo_info "Installing tangram..."
# Add the tangram repository.
curl -fsSL https://pkgs.tangram.dev/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tangram.list
# Install!
sudo apt-get install tangram


for pkg in "${PKGS[@]}"; do
  echo_info "Installing ${pkg}..."
  if ! [ -x "$(command -v rainbow)" ]; then
    sudo apt-get install "$pkg"
  else
    rainbow --red=error --yellow=warning apt-get install "$pkg"
  fi
  echo_done "${pkg} installed!"
done

echo_done "Apps configuration!"
