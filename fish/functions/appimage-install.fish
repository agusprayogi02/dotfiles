function appimage-install
    # ============================================================
    # Configuration
    # ============================================================

    set -l APPIMAGE_DIR "/data/Programs/AppImages"
    set -l ICON_DIR "$APPIMAGE_DIR/icons"
    set -l DESKTOP_DIR "$HOME/.local/share/applications"

    # ============================================================
    # Validate arguments
    # ============================================================

    if test (count $argv) -ne 1
        echo "Usage: appimage-install <AppImage>"
        return 1
    end

    set -l APPIMAGE "$argv[1]"

    if not test -f "$APPIMAGE"
        echo "Error: File '$APPIMAGE' does not exist."
        return 1
    end

    if not string match -rq '\.AppImage$' -- "$APPIMAGE"
        echo "Error: '$APPIMAGE' is not an AppImage."
        return 1
    end

    # Resolve absolute path
    set APPIMAGE (realpath "$APPIMAGE")

    # ============================================================
    # Normalize application name
    # ============================================================

    set -l ORIGINAL_NAME (basename "$APPIMAGE" .AppImage)

    # Examples:
    #   Obsidian-1.13.7       -> Obsidian
    #   Obsidian-v1.13.7      -> Obsidian
    #   Zen-Browser-1.2.3     -> Zen-Browser
    #   Foo-2026.08.22        -> Foo
    set -l APPNAME (string replace -r -- '-v?[0-9]+(\.[0-9]+)+(.*)$' '' "$ORIGINAL_NAME")

    if test -z "$APPNAME"
        set APPNAME "$ORIGINAL_NAME"
    end

    set -l APPIMAGE_NAME "$APPNAME.AppImage"

    # ============================================================
    # Destination
    # ============================================================

    set -l APPIMAGE_DEST "$APPIMAGE_DIR/$APPIMAGE_NAME"
    set -l DESKTOP_FILE "$DESKTOP_DIR/$APPNAME.desktop"

    # ============================================================
    # Determine install/update mode
    # ============================================================

    set -l IS_UPDATE false

    if test -f "$APPIMAGE_DEST"
        set IS_UPDATE true
    end

    echo

    if test "$IS_UPDATE" = true
        set_color yellow
        echo "Updating AppImage"
        set_color normal
    else
        set_color cyan
        echo "Installing AppImage"
        set_color normal
    end

    echo
    echo "  Source:      $APPIMAGE"
    echo "  Application: $APPNAME"
    echo "  Destination: $APPIMAGE_DEST"
    echo

    # ============================================================
    # Temporary directory
    # ============================================================

    set -l TEMP_DIR (mktemp -d)

    # ============================================================
    # Extract AppImage
    # ============================================================

    echo "Extracting AppImage metadata..."

    chmod +x "$APPIMAGE"

    set -l EXTRACT_OUTPUT "$TEMP_DIR/extract.log"

    if not "$APPIMAGE" --appimage-extract >"$EXTRACT_OUTPUT" 2>&1
        echo
        set_color red
        echo "Error: Failed to extract AppImage."
        set_color normal

        cat "$EXTRACT_OUTPUT"

        rm -rf "$TEMP_DIR"
        return 1
    end

    set -l EXTRACTED_DIR "./squashfs-root"

    if not test -d "$EXTRACTED_DIR"
        echo "Error: AppImage extraction directory was not created."
        rm -rf "$TEMP_DIR"
        return 1
    end

    mv "$EXTRACTED_DIR" "$TEMP_DIR/squashfs-root"

    set -l ROOT "$TEMP_DIR/squashfs-root"

    # ============================================================
    # Find .desktop file
    # ============================================================

    set -l DESKTOP_SOURCE ""

    for file in "$ROOT"/*.desktop
        if test -f "$file"
            set DESKTOP_SOURCE "$file"
            break
        end
    end

    if test -z "$DESKTOP_SOURCE"
        set DESKTOP_SOURCE (find "$ROOT" \
            -type f \
            -name "*.desktop" \
            2>/dev/null \
            | head -n 1)
    end

    # ============================================================
    # Read AppImage metadata
    # ============================================================

    set -l METADATA_NAME "$APPNAME"
    set -l METADATA_COMMENT ""
    set -l METADATA_CATEGORIES "Utility"
    set -l METADATA_ICON ""

    if test -n "$DESKTOP_SOURCE"; and test -f "$DESKTOP_SOURCE"

        set -l value (sed -n 's/^Name=//p' "$DESKTOP_SOURCE" | head -n 1)
        if test -n "$value"
            set METADATA_NAME "$value"
        end

        set value (sed -n 's/^Comment=//p' "$DESKTOP_SOURCE" | head -n 1)
        if test -n "$value"
            set METADATA_COMMENT "$value"
        end

        set value (sed -n 's/^Categories=//p' "$DESKTOP_SOURCE" | head -n 1)
        if test -n "$value"
            set METADATA_CATEGORIES "$value"
        end

        set value (sed -n 's/^Icon=//p' "$DESKTOP_SOURCE" | head -n 1)
        if test -n "$value"
            set METADATA_ICON "$value"
        end
    end

    # ============================================================
    # Find icon
    # ============================================================

    set -l ICON_SOURCE ""

    if test -n "$METADATA_ICON"

        set -l ICON_BASENAME (basename "$METADATA_ICON")
        set -l ICON_NO_EXT "$ICON_BASENAME"

        for ext in .png .svg .xpm .ico
            if string match -q "*$ext" "$ICON_NO_EXT"
                set ICON_NO_EXT (string replace "$ext" "" "$ICON_NO_EXT")
            end
        end

        set ICON_SOURCE (find "$ROOT" -type f \( \
            -name "$ICON_BASENAME" \
            -o -name "$ICON_NO_EXT.png" \
            -o -name "$ICON_NO_EXT.svg" \
            -o -name "$ICON_NO_EXT.xpm" \
            \) 2>/dev/null | head -n 1)
    end

    # Fallback icon search
    if test -z "$ICON_SOURCE"

        set ICON_SOURCE (find "$ROOT" -type f \( \
            -name "*.png" \
            -o -name "*.svg" \
            -o -name "*.xpm" \
        \) 2>/dev/null \
            | grep -Ei '/(icon|logo|app|application|product|application-icon)[^/]*\.(png|svg|xpm)$' \
            | head -n 1)
    end

    # Final fallback
    if test -z "$ICON_SOURCE"

        set ICON_SOURCE (find "$ROOT" -type f \( \
            -name "*.png" \
            -o -name "*.svg" \
            -o -name "*.xpm" \
        \) 2>/dev/null \
            | head -n 1)
    end

    # ============================================================
    # INSTALL MODE
    #
    # Ask user for optional metadata only on first install.
    # ============================================================

    if test "$IS_UPDATE" = false

        echo
        set_color yellow
        echo "Application metadata"
        set_color normal
        echo

        echo -n "Category [$METADATA_CATEGORIES]: "
        read -l USER_CATEGORY

        if test -n "$USER_CATEGORY"
            set METADATA_CATEGORIES "$USER_CATEGORY"
        end

        echo -n "Description [$METADATA_COMMENT]: "
        read -l USER_DESCRIPTION

        if test -n "$USER_DESCRIPTION"
            set METADATA_COMMENT "$USER_DESCRIPTION"
        end

    else

        # ========================================================
        # UPDATE MODE
        #
        # No user input.
        # ========================================================

        echo
        set_color yellow
        echo "Existing installation detected."
        set_color normal

        echo "  Existing AppImage:"
        echo "    $APPIMAGE_DEST"

        echo
        echo "Updating directly..."
        echo
    end

    # ============================================================
    # Prepare directories
    # ============================================================

    mkdir -p "$DESKTOP_DIR"

    if not test -d "$APPIMAGE_DIR"
        mkdir -p "$APPIMAGE_DIR"
    end

    if not test -d "$ICON_DIR"
        mkdir -p "$ICON_DIR"
    end

    # ============================================================
    # Install / Replace AppImage
    # ============================================================

    if test "$IS_UPDATE" = true
        echo "Replacing existing AppImage..."
    else
        echo "Installing AppImage..."
    end

    rm -f "$APPIMAGE_DEST"
    mv "$APPIMAGE" "$APPIMAGE_DEST"
    chmod +x "$APPIMAGE_DEST"

    # ============================================================
    # Install icon
    #
    # IMPORTANT:
    # Icons are stored separately:
    #
    # /data/Programs/AppImages/icons/
    # ============================================================

    set -l ICON_DEST ""
    set -l ICON_NAME ""

    if test -n "$ICON_SOURCE"; and test -f "$ICON_SOURCE"

        set -l ICON_EXT (string match -r '\.[^.]+$' (basename "$ICON_SOURCE"))

        if test -z "$ICON_EXT"
            set ICON_EXT ".png"
        end

        set ICON_NAME "$APPNAME$ICON_EXT"
        set ICON_DEST "$ICON_DIR/$ICON_NAME"

        cp "$ICON_SOURCE" "$ICON_DEST"

        echo "Icon: $ICON_DEST"

    else

        if test "$IS_UPDATE" = false
            set_color yellow
            echo "Warning: No icon found inside AppImage."
            set_color normal
        end
    end

    # ============================================================
    # Desktop entry
    # ============================================================

    if test "$IS_UPDATE" = true; and test -f "$DESKTOP_FILE"

        # ========================================================
        # UPDATE:
        # Keep existing metadata.
        # Only update executable and icon.
        # ========================================================

        echo "Keeping existing desktop entry:"
        echo "  $DESKTOP_FILE"

        # Update executable path
        sed -i "s|^Exec=.*|Exec=$APPIMAGE_DEST|" "$DESKTOP_FILE"

        # Update icon if available
        if test -n "$ICON_DEST"

            if grep -q '^Icon=' "$DESKTOP_FILE"
                sed -i "s|^Icon=.*|Icon=$ICON_DEST|" "$DESKTOP_FILE"
            else
                printf '\nIcon=%s\n' "$ICON_DEST" >> "$DESKTOP_FILE"
            end
        end

    else

        # ========================================================
        # INSTALL:
        # Create new desktop entry.
        # ========================================================

        echo "Creating desktop entry..."

        begin
            echo "[Desktop Entry]"
            echo "Name=$METADATA_NAME"
            echo "Comment=$METADATA_COMMENT"
            echo "Exec=$APPIMAGE_DEST"
            echo "Terminal=false"
            echo "Type=Application"
            echo "Categories=$METADATA_CATEGORIES"

            if test -n "$ICON_DEST"
                echo "Icon=$ICON_DEST"
            end
        end > "$DESKTOP_FILE"

        chmod 644 "$DESKTOP_FILE"
    end

    # ============================================================
    # Update desktop database
    # ============================================================

    if type -q update-desktop-database
        update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1
    end

    # ============================================================
    # Cleanup
    # ============================================================

    rm -rf "$TEMP_DIR"

    # ============================================================
    # Done
    # ============================================================

    echo

    if test "$IS_UPDATE" = true

        set_color green
        echo "✓ AppImage updated successfully!"
        set_color normal

    else

        set_color green
        echo "✓ AppImage installed successfully!"
        set_color normal
    end

    echo
    echo "Details:"
    echo "  Name:        $METADATA_NAME"
    echo "  AppImage:    $APPIMAGE_DEST"

    if test -n "$ICON_DEST"
        echo "  Icon:        $ICON_DEST"
    else
        echo "  Icon:        Not found"
    end

    echo "  Category:    $METADATA_CATEGORIES"
    echo "  Description: $METADATA_COMMENT"
    echo "  Desktop:     $DESKTOP_FILE"
    echo
    echo "Done! 🎉"
end
