function kernel-default --description "Pilih kernel default untuk boot berikutnya"
    if not command -sq grubby
        echo "Error: grubby tidak ditemukan." >&2
        return 127
    end

    set -l kernels
    for kernel in /boot/vmlinuz-*
        if test -f "$kernel"; and not string match -q '*/vmlinuz-0-rescue-*' -- "$kernel"
            set -a kernels "$kernel"
        end
    end

    if test (count $kernels) -eq 0
        echo "Error: tidak ada kernel yang ditemukan di /boot." >&2
        return 1
    end

    set -l selected
    if test (count $argv) -gt 1
        echo "Penggunaan: kernel-default [VERSI|PATH_KERNEL]" >&2
        return 2
    else if test (count $argv) -eq 1
        if test -f "$argv[1]"
            set selected (realpath "$argv[1]")
        else
            set -l matches
            for kernel in $kernels
                if string match -q "*$argv[1]*" -- "$kernel"
                    set -a matches "$kernel"
                end
            end

            if test (count $matches) -ne 1
                echo "Error: versi '$argv[1]' cocok dengan "(count $matches)" kernel." >&2
                printf '  %s\n' $matches >&2
                return 1
            end
            set selected "$matches[1]"
        end
    else
        if not command -sq fzf
            echo "Error: fzf tidak ditemukan. Berikan versi kernel sebagai argumen." >&2
            printf '  %s\n' $kernels >&2
            return 127
        end

        set selected (printf '%s\n' $kernels | sort -V -r | fzf \
            --prompt='Pilih kernel default > ' \
            --height=60% \
            --layout=reverse \
            --border \
            --header='ENTER: pilih | ESC: batal')

        if test -z "$selected"
            echo "Pemilihan kernel dibatalkan."
            return 0
        end
    end

    if not contains -- "$selected" $kernels
        echo "Error: '$selected' bukan kernel yang tersedia di /boot." >&2
        return 1
    end

    echo "Mengatur kernel default ke: $selected"
    sudo grubby --set-default "$selected"
    or return $status

    set -l current (grubby --default-kernel 2>/dev/null)
    if test "$current" = "$selected"
        echo "Kernel default berhasil diperbarui: $current"
    else
        echo "Kernel telah diatur, tetapi hasil verifikasi berbeda: $current" >&2
        return 1
    end
end
