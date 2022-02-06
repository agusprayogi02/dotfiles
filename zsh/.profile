# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	source "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


#Custom PATH
export MEDIA=/media/agus
export SSD1=$MEDIA/SSD1
export SSD2=$MEDIA/SSD2
export HDD1=$MEDIA/HDD1
export HDD2=$MEDIA/HDD2
export ANDROID_HOME=$SSD2/LINUX_AND_SDK
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export FLUTTER_HOME=$SSD2/src/flutter
export PATH=$FLUTTER_HOME/bin:$PATH
export PATH=$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH
export XAMPP=/opt/lampp
export PATH=$XAMPP:$PATH:$XAMPP/bin
export PATH=$PATH:"$SSD2/Program Files/composer"
export LinuxApp=$SSD2/LinuxApp
