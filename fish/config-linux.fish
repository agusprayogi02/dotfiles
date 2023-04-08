#Custom PATH
set -x MEDIA /run/media/agus
set -x SSD1 $MEDIA/SSD1
set -x SSD2 $MEDIA/SSD2
set -x HDD1 $MEDIA/HDD1
set -x HDD2 $MEDIA/HDD2
set -x PROKU $SSD1/ProjectKu
set -x ANDROID_HOME $SSD2/LINUX_AND_SDK
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -x PATH $ANDROID_HOME/emulator $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH
set -x PATH $ANDROID_HOME/ndk/24.0.8215888 $PATH
set -x PATH $HOME/.dotnet/tools $PATH

set -x FLUTTER_HOME $SSD2/src/flutter
set -x RUSTUP_HOME $HOME/.rustup
set -x CARGO_HOME $HOME/.cargo

set -x PATH $FLUTTER_HOME/bin $PATH
set -x PATH $FLUTTER_HOME/bin/cache/dart-sdk/bin $PATH
set -x XAMPP /opt/lampp
set -x PATH $XAMPP $PATH $XAMPP/bin
set -x PATH ~/julia-1.8.5/bin $PATH
# set -x PATH $PATH "$SSD2/Program Files/composer"
set -x LinuxApp $SSD2/LinuxApp
set -x PATH $PATH $LinuxApp/composer
set -x PATH $PATH $LinuxApp/apache-maven/bin
set -x PATH $PATH $LinuxApp/blender
set -x PATH $PATH $LinuxApp/NetBeans-14/netbeans/bin
# set -x ANDROID_STUDIO $LinuxApp/android-studio
# set -x PATH $PATH $ANDROID_STUDIO/bin

set -x PATH $PATH $HOME/.local/share/JetBrains/Toolbox/scripts

set -x JAVA_HOME /usr/lib/jvm/default
set -x PATH $PATH $JAVA_HOME/bin
set -x PATH $PATH $HOME/.pub-cache/bin
set -x PATH $PATH $HOME/.config/composer/vendor/bin
set -x FVM_HOME $SSD2/src
set -x FakeCam $HDD1/Program/Linux/WebCam/Linux-Fake-Background-Webcam
set -x GOROOT /usr/local/go
set -x GOPATH $HOME/go
set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH $HOME/.local/bin
set -x PATH $PATH $HDD1/Program/genymotion
set -x PATH (yarn global bin) $PATH
set -x PATH ~/.npm-global/bin $PATH

set -x CHROME_EXECUTABLE /usr/bin/google-chrome-stable

set -x WINEARCH win32
set -x WINEPREFIX ~/.wine32
