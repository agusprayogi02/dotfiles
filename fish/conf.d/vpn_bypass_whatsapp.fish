status is-interactive; or return

function sync_whatsapp_vpn_bypass
    set vpn_name "ecentrix_AgusPrayogi_intelix-vpn"
    
    # Deteksi gateway lokal dari Wi-Fi secara realtime
    set local_gateway (nmcli dev show wlp1s0 | string match -r 'IP4.GATEWAY:\s*(.*)' | string replace -r 'IP4.GATEWAY:\s*' '')

    if test -n "$local_gateway"
        # Daftar IP WhatsApp Web / Meta
        set whatsapp_ips "157.240.0.0/16" "31.13.0.0/16" "174.129.0.0/16"
        set routes_format ""
        for ip in $whatsapp_ips
            set routes_format "$routes_format $ip $local_gateway,"
        end
        set routes_format (string trim -c ',' $routes_format)

        # Cek rute tersimpan saat ini di profil NetworkManager
        set current_routes (nmcli -g ipv4.routes connection show "$vpn_name" 2>/dev/null)

        # HANYA modifikasi rute profil jika gateway berubah (misal pindah Wi-Fi rumah ke warkop)
        if not string match -q "*$local_gateway*" "$current_routes"
            # Menggunakan perintah user-level biasa tanpa memicu request password up/down
            nmcli connection modify "$vpn_name" ipv4.routes "$routes_format" 2>/dev/null
        end
    end
end

sync_whatsapp_vpn_bypass
