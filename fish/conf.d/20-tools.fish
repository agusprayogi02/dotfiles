# ============================================================
# Interactive CLI integrations
# ============================================================

if not status is-interactive
    return
end

# Starship prompt
if type -q starship
    starship init fish | source
end

# Smart directory navigation
if type -q zoxide
    zoxide init fish | source
end

# Advanced shell history
if type -q atuin
    atuin init fish | source
end

# Per-project environment variables
if type -q direnv
    direnv hook fish | source
end

# mise is a tool for managing multiple versions of software. It can be used to switch between different versions of programming languages, libraries, and other tools. The `mise activate fish` command activates the fish shell integration for mise, allowing you to easily switch between different versions of software while using the fish shell.
if type -q mise
    mise activate fish | source
end