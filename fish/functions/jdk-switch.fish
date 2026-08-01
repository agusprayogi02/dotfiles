function jdk-switch --description "Pilih dan aktifkan versi JDK"

    set -l jdk_list

    # Cari direktori atau symlink yang mengandung kata "jdk"
    for jdk_path in /usr/lib/jvm/*jdk*
        if test -d "$jdk_path"; and test -x "$jdk_path/bin/java"
            set -a jdk_list (realpath "$jdk_path")
        end
    end

    # Hilangkan path duplikat
    set jdk_list (printf "%s\n" $jdk_list | sort -u)

    if test (count $jdk_list) -eq 0
        echo "Tidak ditemukan JDK valid di /usr/lib/jvm/"
        return 1
    end

    # Tampilkan pilihan interaktif
    set -l selected_jdk (
        for jdk_path in $jdk_list
            set -l java_version (
                "$jdk_path/bin/java" -version 2>&1 |
                string match -r 'version "[^"]+"' |
                head -n 1
            )

            printf "%-55s %s\n" "$jdk_path" "$java_version"
        end |
        fzf \
            --prompt="Pilih JDK > " \
            --height=60% \
            --layout=reverse \
            --border \
            --header="ENTER: pilih | ESC: batal" |
        awk '{print $1}'
    )

    if test -z "$selected_jdk"
        echo "Pemilihan JDK dibatalkan."
        return 0
    end

    #
    # Simpan JAVA_HOME secara permanen sebagai universal variable
    #
    set -x JAVA_HOME "$selected_jdk"

    #
    # Hapus semua path Java lama dari fish_user_paths
    #
    set -l cleaned_paths

    for current_path in $fish_user_paths
        if not string match -qr '^/usr/lib/jvm/.*/bin/?$' "$current_path"
            set -a cleaned_paths "$current_path"
        end
    end

    #
    # Tambahkan Java yang baru ke urutan paling depan
    #
    set -U fish_user_paths "$JAVA_HOME/bin" $cleaned_paths

    # Bersihkan cache command Fish
    hash -r

    echo
    echo "JDK berhasil diaktifkan"
    echo "JAVA_HOME : $JAVA_HOME"
    echo "Java path : "(command -v java)
    echo

    java -version

    if test -x "$JAVA_HOME/bin/javac"
        echo
        javac -version
    end
end
