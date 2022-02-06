#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring snap..."
sudo apt install snapd
echo_info "Installing snap core..."
sudo snap install core
echo_info "Installing snap pkgs..."

PKGS=(
  breaktimer # Manage periodic breaks. Avoid eye-strain and RSI.
  colorpicker-app # A mininal but complete Colorpicker desktop app
  taskbook # Tasks, boards & notes for the command-line habitat.
  insomnia # Insomnia REST Client
  fkill # Fabulously kill processes. Cross-platform.
  mutt # Mutt is a sophisticated text-based Mail User Agent.
  youtube-dl # Download videos from youtube.com or other video platforms.
  # docker # Docker container runtime.
  robo3t-snap # Robo 3T (formerly Robomongo) is the free lightweight GUI for MongoDB enthusiasts.
)

for pkg in "${PKGS[@]}"; do
  echo_info "Installing ${pkg}..."
  if ! [ -x "$(command -v rainbow)" ]; then
    sudo snap install "$pkg"
  else
    rainbow --red=error --yellow=warning snap install "$pkg"
  fi
  echo_done "${pkg} installed!"
done

echo_info "Configuring Docker..."
sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  bullseye stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo_info "Installing Docker..."
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo_info "trying Docker running..."
sudo docker run hello-world

echo_info "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo_info "Installing VSCode..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

CLASSIC_PKGS=(
  # cool-retro-term # cool-retro-term is a terminal emulator.
  # code # Visual Studio Code. Code editing. Redefined.
  gitkraken # For repo management, in-app code editing & issue tracking.
  hollywood # fill your console with Hollywood melodrama technobabble.
  # heroku # CLI client for Heroku.
  # datagrip # IntelliJ-based IDE for databases and SQL
)

for pkg in "${CLASSIC_PKGS[@]}"; do
  echo_info "Installing ${pkg}..."
  if ! [ -x "$(command -v rainbow)" ]; then
    sudo snap install "$pkg" --classic
  else
    rainbow --red=error --yellow=warning snap install "$pkg"
  fi
  echo_done "${pkg} installed!"
done

echo_done "snap configuration!"
