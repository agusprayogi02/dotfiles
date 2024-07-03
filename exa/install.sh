#!/bin/bash

# shellcheck source=distro.sh
. ../distro.sh
# shellcheck source=helpers.sh
. ../helpers.sh

echo_info "Installing exa..."
sudo apt-get install exa

echo_done "exa configuration!"
