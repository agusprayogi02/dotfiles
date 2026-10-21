function install-tools --description "Install semua tool dev dari sumber resmi (skip yang sudah ada)"
    set -l failed

    # --- mise (dipakai untuk php) ---
    if not type -q mise
        echo "→ mise (mise.run)"
        curl -sSf https://mise.run | sh; or set -a failed mise
    end

    # --- rust / cargo (rustup.rs) ---
    if not type -q cargo
        echo "→ rust / cargo (rustup.rs)"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        or set -a failed rust
    end

    # --- golang → GOROOT (~/.config/FlyEnv/env/golang), tarball resmi go.dev ---
    set -l goroot ~/.config/FlyEnv/env/golang
    if set -q GOROOT; and test -n "$GOROOT"
        set goroot $GOROOT
    end
    if not test -x $goroot/bin/go
        echo "→ golang (go.dev) → $goroot"
        set -l ver (curl -s 'https://go.dev/VERSION?m=text' | head -n1)
        set -l tmp (mktemp -d)
        if test -n "$ver"; and curl -fsL -o $tmp/go.tgz "https://go.dev/dl/$ver.linux-amd64.tar.gz"
            rm -rf $goroot; and mkdir -p $goroot
            and tar -xzf $tmp/go.tgz -C $goroot --strip-components=1
            or set -a failed golang
        else
            set -a failed golang
        end
        rm -rf $tmp
    end

    # --- nginx (repo resmi Fedora) ---
    type -q nginx; or begin
        echo "→ nginx (dnf)"
        sudo dnf install -y nginx; or set -a failed nginx
    end

    # --- php via mise (build dari source → butuh build deps) ---
    if type -q mise; and not mise which php >/dev/null 2>&1
        echo "→ php: dependency build (dnf)"
        sudo dnf install -y gcc make autoconf bison re2c pkgconf-pkg-config \
            oniguruma-devel libxml2-devel sqlite-devel bzip2-devel libcurl-devel \
            libjpeg-turbo-devel libwebp-devel libsodium-devel gmp-devel \
            readline-devel libzip-devel openssl-devel libicu-devel
        or set -a failed php-deps
        echo "→ php (mise)"
        mise use -g php@latest; or set -a failed php
    end

    # --- git (repo resmi Fedora) ---
    type -q git; or begin
        echo "→ git (dnf)"
        sudo dnf install -y git; or set -a failed git
    end

    # --- bun (bun.sh resmi) ---
    type -q bun; or begin
        echo "→ bun (bun.sh)"
        curl -fsSL https://bun.sh/install | bash; or set -a failed bun
    end

    # --- temurin-jdk-25 (repo resmi Adoptium) ---
    if not rpm -q temurin-25-jdk >/dev/null 2>&1
        echo "→ temurin-25-jdk (Adoptium repo)"
        if not test -f /etc/yum.repos.d/adoptium.repo
            printf '%s\n' \
                '[Adoptium]' \
                'name=Adoptium' \
                'baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$releasever/$basearch' \
                'enabled=1' \
                'gpgcheck=1' \
                'gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public' \
                | sudo tee /etc/yum.repos.d/adoptium.repo >/dev/null; or set -a failed temurin-25
        end
        sudo dnf install -y temurin-25-jdk; or set -a failed temurin-25
    end

    # --- nvm + nodejs LTS (nvm-sh resmi) ---
    if not test -s ~/.nvm/nvm.sh
        echo "→ nvm (github nvm-sh)"
        set -l tag (curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest \
            | string match -r '"tag_name":\s*"\K[^"]+')
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$tag/install.sh" | bash
        or set -a failed nvm
    end
    if test -s ~/.nvm/nvm.sh
        echo "→ nodejs LTS (nvm)"
        bash -c 'export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm install --lts'
        or set -a failed nodejs
    end

    if set -q failed[1]
        echo
        echo "✗ gagal: $failed"
        return 1
    end
    echo
    echo "✓ semua tool siap (buka shell baru atau 'hash -r' agar PATH ter-refresh)"
end
