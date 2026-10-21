#Custom PATH
set -x TASK_EXE go-task
set -x MEDIA /data
set -x SSD1 $MEDIA/Projects
set -x SSD2 $MEDIA/Programs
set -x HDD1 $MEDIA/HDD1
set -x HDD2 $MEDIA/HDD2
set -x PROKU $SSD1/ProjectKu
set -x ANDROID_HOME $SSD2/AndroidSdk
set -x PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -x PATH $ANDROID_HOME/emulator $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH
set -x PATH $ANDROID_HOME/ndk/24.0.8215888 $PATH
set -x PATH $HOME/.dotnet/tools $PATH

set -x FLUTTER_HOME $SSD2/Flutter/default
set -x RUSTUP_HOME $HOME/.rustup
set -x CARGO_HOME $HOME/.cargo
set -x PATH $CARGO_HOME/bin $PATH

set -x PATH $FLUTTER_HOME/bin $PATH
set -x PATH $FLUTTER_HOME/dev $PATH
set -x PATH $FLUTTER_HOME/packages $PATH
set -x PATH $FLUTTER_HOME/bin/cache/dart-sdk/bin $PATH
set -x XAMPP /opt/lampp
set -x PATH $XAMPP $PATH $XAMPP/bin
set -x PATH ~/julia-1.8.5/bin $PATH
# set -x PATH $PATH "$SSD2/Program Files/composer"
set -x PATH $PATH $SSD2/Program

set -x LinuxApp $SSD2/LinuxApp
set -x PATH $PATH $LinuxApp/composer
set -x PATH $PATH $LinuxApp/apache-maven/bin
set -x PATH $PATH $LinuxApp/blender
set -x PATH $PATH $LinuxApp/NetBeans-14/netbeans/bin
set -x ANDROID_STUDIO /data/Programs/Jetbrains/android-studio
set -x PATH $PATH $ANDROID_STUDIO/bin

set -x PATH $PATH $HOME/.local/share/JetBrains/Toolbox/scripts

# set -x JAVA_HOME /usr/lib/jvm/java-25-temurin-jdk
# set -x PATH $PATH $JAVA_HOME/bin
set -x PATH $PATH $HOME/.pub-cache/bin
set -x PATH $PATH $HOME/.config/composer/vendor/bin
set -x FVM_CACHE_PATH $SSD2/Flutter
set -x FakeCam $HDD1/Program/Linux/WebCam/Linux-Fake-Background-Webcam

set -x GOROOT /home/agus/.config/FlyEnv/env/golang
set -x GOPATH $HOME/go
set -x PATH $PATH $GOROOT/bin
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH $HOME/.local/bin
set -x PATH $PATH /data/Containers/Genymotion/genymotion
#set -x PATH (yarn global bin) $PATH
set -x PATH ~/.npm-global/bin $PATH

set -x CHROME_EXECUTABLE /usr/bin/google-chrome-stable

set -x WINEARCH win32
set -x WINEPREFIX ~/.wine32
set -x JUPYTER_RUNTIME_DIR /tmp

set -x PATH $PATH $HOME/.bun/bin
set -x PATH $HOME/.local/share/fnm $PATH

# FlyEnv
set -x PATH $HOME/.config/FlyEnv/alias /home/agus/.config/FlyEnv/env/composer /home/agus/.config/FlyEnv/env/rust/bin /home/agus/.config/FlyEnv/env/bun /home/agus/.config/FlyEnv/env/caddy /home/agus/.config/FlyEnv/env/mailpit /home/agus/.config/FlyEnv/env/mysql /home/agus/.config/FlyEnv/env/mysql/bin /home/agus/.config/FlyEnv/env/nginx /home/agus/.config/FlyEnv/env/nginx/sbin /home/agus/.config/FlyEnv/env/php /home/agus/.config/FlyEnv/env/php/bin /home/agus/.config/FlyEnv/env/postgresql /home/agus/.config/FlyEnv/env/postgresql/bin /home/agus/.config/FlyEnv/env/redis /home/agus/.config/FlyEnv/env/redis/bin /home/agus/.config/FlyEnv/env/maven/bin /home/agus/.config/FlyEnv/env/node/bin $PATH
set -x PATH $GOROOT/bin $PATH

# Node dari nvm (alias default) — menang atas node FlyEnv. Resolve chain: default → lts/* → lts/krypton → vX
if test -d ~/.nvm/versions/node
    set -l __nv (string trim < ~/.nvm/alias/default 2>/dev/null)
    set -l __i 0
    while string match -q -- '*/*' "$__nv"; and test $__i -lt 5
        set __nv (string trim < ~/.nvm/alias/$__nv 2>/dev/null)
        set __i (math $__i + 1)
    end
    set -l __nb
    test -x "$HOME/.nvm/versions/node/$__nv/bin/node"; and set __nb $HOME/.nvm/versions/node/$__nv/bin
    # alias default hilang/kosong → pakai versi terpasang tertinggi
    if not set -q __nb[1]
        set -l __all (ls -d $HOME/.nvm/versions/node/*/bin 2>/dev/null | sort -V)
        test -n "$__all"; and set __nb $__all[-1]
    end
    if set -q __nb[1]
        # buang entri node nvm lama dari PATH warisan agar tidak menumpuk
        set -x PATH (string match -v -r "^$HOME/.nvm/versions/node/[^/]+/bin\$" $PATH)
        set -x PATH $__nb $PATH
    end
end

set EDITOR nvim
set VISUAL nvim
