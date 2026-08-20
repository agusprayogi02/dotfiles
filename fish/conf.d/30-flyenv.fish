# Fish-compatible version of FlyEnv loader

set -g _flyenv_allowed_paths
set -g _flyenv_config_hash ""
set -g _flyenv_loaded_dir ""

function _flyenv_msg
    set -l color $argv[1]
    set -e argv[1]
    switch $color
        case red
            set_color red
        case green
            set_color green
        case cyan
            set_color cyan
        case '*'
            set_color normal
    end
    if test (count $argv) -eq 0
        echo "[FlyEnv]"
    else
        echo "[FlyEnv] $argv"
    end
    set_color normal
end

function _flyenv_reload
    set -l config_file "$HOME/.config/FlyEnv/bin/.flyenv.dir"
    if not test -f "$config_file"
        set -g _flyenv_allowed_paths
        return 0
    end

    set -l new_hash (sha256sum "$config_file" 2>/dev/null | string split " ")[1]
    if test "$new_hash" = "$_flyenv_config_hash"
        return 0
    end

    set -g _flyenv_config_hash "$new_hash"
    set -g _flyenv_allowed_paths

    for line in (cat "$config_file")
        set -l clean_dir (string trim "$line")
        if string match -rq '^/' -- "$clean_dir"
            set clean_dir (realpath -m "$clean_dir" 2>/dev/null | string replace -r '/+$' '')
            if test -n "$clean_dir"
                set -a _flyenv_allowed_paths "$clean_dir"
            end
        end
    end
    return 0
end

function flyenv_autoload --on-variable PWD
    _flyenv_reload || return 0
    set -l current_path "$PWD"
    set -l found 0

    for allow_path in $_flyenv_allowed_paths
        if test "$allow_path" = "$current_path"
            set found 1
            break
        end
    end

    if test $found -eq 0
        set -g _flyenv_loaded_dir ""
        return 0
    end

    if test -f ".flyenv"
        if test "$_flyenv_loaded_dir" = "$current_path"
            return 0
        end

        _flyenv_msg cyan "Loading environment variables..."

        set -l success 1
        for line in (cat .flyenv)
            set -l clean (string replace -r '#.*$' '' -- $line | string trim)
            if string match -rq '^export\s+(?<var>[A-Za-z_][A-Za-z0-9_]*)=(?<val>.*)$' -- $clean
                set val (string replace -r '^["\']|["\']$' '' -- $val)
                if test "$var" = "PATH"
                    set -l path_entries (string split ':' -- $val)
                    for i in (seq (count $path_entries) -1 1)
                        set -l p $path_entries[$i]
                        if test "$p" != '$PATH' -a "$p" != '${PATH}' -a -d "$p"
                            fish_add_path -m -p "$p"
                        end
                    end
                else
                    set -gx $var "$val"
                end
            end
        end

        if test $success -eq 1
            set -g _flyenv_loaded_dir "$current_path"
            _flyenv_msg green "✓ Load successful"
        else
            _flyenv_msg red "✗ Load failed"
        end
    end
end

# Initial load on shell startup
flyenv_autoload
