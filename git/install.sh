#!/bin/bash

name="Agus Prayogi"
email="agus21apy@gmail.com"

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Configuring GIT..."
mkdir -p ${HOME}/.git

echo_info "Installing GIT..."
sudo apt-get install git

echo_done "GIT configuration!"
