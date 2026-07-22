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