if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

#Custom PATH
set -gx MEDIA /run/media/agus
set -gx SSD1 $MEDIA/SSD1
set -gx SSD2 $MEDIA/SSD2
set -gx HDD1 $MEDIA/HDD1
set -gx HDD2 $MEDIA/HDD2
set -gx PROKU $SSD1/ProjectKu
set -gx ANDROID_SDK_ROOT $SSD2/LINUX_AND_SDK
set -gx PATH $ANDROID_SDK_ROOT/cmdline-tools/latest/bin $PATH
set -gx PATH $ANDROID_SDK_ROOT/emulator $PATH
set -gx PATH $ANDROID_SDK_ROOT/platform-tools $PATH
set -gx FLUTTER_HOME $SSD2/src/flutter
set -gx PATH $FLUTTER_HOME/bin $PATH
set -gx PATH $FLUTTER_HOME/bin/cache/dart-sdk/bin $PATH
set -gx XAMPP /opt/lampp
set -gx PATH $XAMPP/bin $PATH
set -gx PATH "$SSD2/Program Files/composer" $PATH
set -gx LinuxApp $SSD2/LinuxApp
set -gx PATH $LinuxApp/apache-maven/bin $PATH 
set -gx PATH $LinuxApp/Godot-Mono $PATH
set -gx PATH $LinuxApp/postgrest $PATH
set -gx PATH $LinuxApp/blender $PATH
set -gx PATH $LinuxApp/netbeans-12.6/netbeans/bin $PATH 
set -gx ANDROID_STUDIO $LinuxApp/android-studio
set -gx PATH $ANDROID_STUDIO/bin $PATH 
set -gx PATH $HDD1/Program/genymotion $PATH

set -gx JAVA_HOME /usr/lib/jvm/default
set -gx PATH $JAVA_HOME/bin $PATH
set -gx PATH $HOME/.pub-cache/bin $PATH
set -gx PATH $HOME/.config/composer/vendor/bin $PATH
set -gx FVM_HOME $SSD2/src
set -gx FakeCam $HDD1/Program/Linux/WebCam/Linux-Fake-Background-Webcam
set -gx GOROOT /usr/lib/go
set -gx GOPATH $HOME/go
set -gx PATH $GOROOT/bin $PATH
set -gx PATH $GOPATH/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.local/share/genymotion $PATH

set -gx CHROME_EXECUTABLE /opt/google/chrome/google-chrome
