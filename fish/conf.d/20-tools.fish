# ============================================================
# Interactive CLI integrations
# ============================================================

if not status is-interactive
    return
end

# Dir instalasi user-level masuk PATH SEBELUM cek tool: conf.d ini jalan sebelum
# *.env.fish (mis. atuin.env.fish dari installer atuin) yang biasanya menambah PATH.
for __d in ~/.local/bin ~/.atuin/bin ~/.cargo/bin ~/.bun/bin
    test -d $__d; and not contains -- $__d $PATH; and set -gx PATH $__d $PATH
end

# Install helper: pakai repo Fedora (dnf) kalau tersedia, selain itu installer resmi upstream.
# ponytail: install jalan sinkron saat shell start & tanpa cache "sudah gagal"; kalau gagal
# (mis. sudo dibatalkan) akan dicoba lagi di shell berikutnya. Pindah ke `make install` kalau mengganggu.
function __ensure_tool --argument-names bin origin cmd
    type -q $bin; and return 0
    echo "→ $bin belum terpasang, install dari $origin"
    string join ' ' $cmd | source
end

# Starship prompt (tidak ada di repo Fedora → installer resmi starship.rs, ke ~/.local/bin)
__ensure_tool starship "starship.rs (official install script)" \
    'curl -sSf https://starship.rs/install.sh | sh -s -- -y --bin-dir ~/.local/bin'

# Smart directory navigation
__ensure_tool zoxide "repo resmi Fedora" 'sudo dnf install -y zoxide'

# Advanced shell history
__ensure_tool atuin "repo resmi Fedora" "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive"

# Per-project environment variables
__ensure_tool direnv "repo resmi Fedora" 'sudo dnf install -y direnv'

# mise is a tool for managing multiple versions of software. It can be used to switch between different versions of programming languages, libraries, and other tools. The `mise activate fish` command activates the fish shell integration for mise, allowing you to easily switch between different versions of software while using the fish shell.
# (tidak ada di repo Fedora → installer resmi mise.run, ke ~/.local/bin)
__ensure_tool mise "mise.run (official install script)" 'curl -sSf https://mise.run | sh'

__ensure_tool go-task "repo resmi Fedora" 'sudo dnf install -y go-task'

## Run fastfetch if session is interactive
__ensure_tool fastfetch "repo resmi Fedora" 'sudo dnf install -y fastfetch'

# Starship prompt
if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q atuin
    atuin init fish | source
end

if type -q direnv
    direnv hook fish | source
end

if type -q mise
    mise activate fish | source
end

if type -q go-task
    go-task --completion fish | source
end

if type -q fastfetch
    fastfetch
end
