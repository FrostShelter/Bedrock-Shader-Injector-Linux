#!/bin/bash

# --- Setup Paths ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$SCRIPT_DIR/.path_config"
NEWB_DIR="$SCRIPT_DIR/MaterialsFiles"
BACKUP_DIR="$SCRIPT_DIR/Backups"

# Create directories
mkdir -p "$NEWB_DIR" "$BACKUP_DIR"

# --- Check/Get Game Path & Auto-Backup ---
if [ -f "$CONFIG_FILE" ]; then
    GAME_PATH=$(cat "$CONFIG_FILE")
else
    clear
    echo "--- 🛠️ Initial Setup ---"
    echo "Bro, I need to know where your Minecraft 'materials' folder is."
    echo "Example: /home/natto/.var/app/com.trench.trinity.launcher/data/mcpelauncher/versions/MC 1.26.3.1/assets/assets/renderer/materials/"
    echo "----------------------------------------------------------------"
    read -p "Paste the path here, bro: " user_path

    # Remove trailing slash if exists
    GAME_PATH="${user_path%/}"

    # Check if the path is valid before saving
    if [ -d "$GAME_PATH" ]; then
        echo "$GAME_PATH" > "$CONFIG_FILE"
        echo "✅ Path saved! Now hold on, I'm backing up your original files... (づ｡◕‿‿◕｡)づ"

        # Auto-backup: Copy all .bin files from game to Backups folder
        cp -v "$GAME_PATH"/*.bin "$BACKUP_DIR/"

        echo "=> Backup complete! Your original files are safe in $BACKUP_DIR."
        sleep 2
    else
        echo "❌ That's a fake path, bro! Run the script again and give me a real one. :(("
        exit 1
    fi
fi

clear
echo "--- 🎮 Universal Bedrock Shader Injector ---"
echo "📍 Game Path: $GAME_PATH"
echo "--------------------------------------------"
echo "1. Inject Shaders (MaterialsFiles -> Game) 🚀"
echo "2. Restore Vanilla (Backups -> Game) 🧹"
echo "3. Reset Game Path & Config 🔄"
echo "--------------------------------------------"
read -p "Make a choice, bro! (1, 2 or 3): " choice

case $choice in
    1)
        echo "Injecting shaders... Buckle up! (づ｡◕‿‿◕｡)づ"
        # Check if there are any .bin files in Shader folder
        if ls "$NEWB_DIR"/*.bin 1> /dev/null 2>&1; then
            cp -v "$NEWB_DIR"/*.bin "$GAME_PATH/"
            echo "=> Done! Now go touch some (blocky) grass, bro. :)))"
        else
            echo "❌ Damn it! MaterialsFiles is EMPTY, bro. What am I supposed to inject? Air? :(("
        fi
        ;;
    2)
        echo "Cleaning up your mess... Returning to Vanilla. <3"
        # Check if there are any .bin files in Backup folder
        if ls "$BACKUP_DIR"/*.bin 1> /dev/null 2>&1; then
            cp -v "$BACKUP_DIR"/*.bin "$GAME_PATH/"
            echo "=> Back to basic. Happy now, bro? =)))"
        else
            echo "❌ System Error: Backups folder is empty. Can't restore squat! =)))"
        fi
        ;;
    3)
        rm "$CONFIG_FILE"
        echo "✅ Config nuked! Run the script again to set a new path and re-backup, bro."
        ;;
    *)
        echo "Bruh... It's just 1, 2, or 3. How did you mess that up? =))"
        ;;
esac
