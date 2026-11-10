function serve -d "Serve current directory over HTTP (dufs, exposed on Tailscale)"
    argparse -n serve 'h/help' 'a/all' 'r/read-only' 's/spa' 'b/bind=' 'p/port=' 'd/dir=' 'auth=' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: serve [-p PORT] [-b ADDR] [-d DIR] [OPTIONS]"
        echo
        echo "Serve the current directory over HTTP with dufs (upload, delete,"
        echo "search, folder zip download, Range/streaming support)."
        echo
        echo "  -p, --port PORT     Port to listen on (default: 8000)"
        echo "  -b, --bind ADDR     Address to bind (default: Tailscale IP, else 0.0.0.0)"
        echo "  -d, --dir DIR       Directory to serve (default: current directory)"
        echo "  -a, --all           Bind 0.0.0.0 instead of the Tailscale IP"
        echo "  -r, --read-only     Disable upload/delete/search (view & download only)"
        echo "  -s, --spa           Serve index.html for unknown paths (SPA mode)"
        echo "      --auth USER:PASS  Require basic auth"
        return 0
    end

    set -l port 8000
    set -q _flag_port[1]; and set port $_flag_port[1]

    set -l dir $PWD
    set -q _flag_dir[1]; and set dir $_flag_dir[1]

    if not test -d $dir
        echo "serve: no such directory: $dir" >&2
        return 1
    end

    set -l bind 0.0.0.0
    set -l ts_ip ""
    if not set -q _flag_all
        if command -q tailscale
            set ts_ip (command tailscale ip -4 2>/dev/null | head -n1)
            test -n "$ts_ip"; and set bind $ts_ip
        end
    end
    set -q _flag_bind[1]; and set bind $_flag_bind[1]

    echo "Serving $dir"
    if test "$bind" = 0.0.0.0
        set -l lan_ip (hostname -I 2>/dev/null | string split ' ' | head -n1)
        echo "  local:     http://127.0.0.1:$port/"
        echo "  exposed:   http://$lan_ip:$port/  (0.0.0.0)"
    else
        echo "  exposed:   http://$bind:$port/"
    end

    if command -q dufs
        set -l opts
        if set -q _flag_read_only
            set opts $opts --allow-search
        else
            set opts $opts --allow-all
        end
        set -q _flag_spa; and set opts $opts --render-spa
        if set -q _flag_auth[1]
            set -l rule $_flag_auth[1]
            if not string match -q '*@*' -- $rule
                if set -q _flag_read_only
                    set rule "$rule@/"
                else
                    set rule "$rule@/:rw"
                end
            end
            set opts $opts --auth $rule
            echo "  auth:      $rule"
        end
        echo "  mode:      "(set -q _flag_read_only; and echo "read-only"; or echo "upload/delete enabled")
        command dufs $dir --bind $bind --port $port $opts
    else
        echo "  mode:      read-only (dufs not found, falling back to python3)" >&2
        command python3 -m http.server $port --bind $bind --directory $dir
    end
end
