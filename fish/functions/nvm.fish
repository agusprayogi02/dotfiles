function __nvm_sync --description "Sinkronkan PATH fish ke versi node nvm yang aktif"
    set -l bin (bash -c 'export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh" >/dev/null 2>&1; dirname (nvm which current 2>/dev/null)' 2>/dev/null)
    test -d "$bin"; or return 1
    set -gx PATH (string match -v -r "^$HOME/.nvm/versions/node/[^/]+/bin\$" $PATH)
    set -gx PATH $bin $PATH
    echo "node "(command node -v)" → $bin"
end

function nvm --description "nvm (bash) + sinkron PATH ke fish"
    if not test -s ~/.nvm/nvm.sh
        echo "nvm belum terpasang — jalankan: install-tools"
        return 1
    end
    bash -c 'export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm "$@"' -- $argv
    set -l ret $status
    __nvm_sync
    return $ret
end
