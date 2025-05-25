MUSIC_PID=""

SCRIPT_DIR="$(dirname "$BASH_SOURCE")"

BASHRC="$HOME/.bashrc"
BASHRC_BAK="$HOME/.bashrc.bak"

BUILDR_MODE=0

BUILDR_MODE_PROMPT="\[\e[1;31m\][BUILDING...]\[\e[0m\] \u@\h:\w\$ "

BUILDR_MODE_BLOCK_MARKER_START="# >>> BUILDER MODE BLOCK START >>>"
BUILDR_MODE_BLOCK_MARKER_END="# <<< BUILDER MODE BLOCK END <<<"

BUILDR_MODE_BLOCK=$(cat << _END_OF_BLOCK_
    $BUILDR_MODE_BLOCK_MARKER_START
    export PS1="$BUILDR_MODE_PROMPT"
    $BUILDR_MODE_BLOCK_MARKER_END
_END_OF_BLOCK_
)

# Type 'buildr' to enter builder mode
buildr() {

    if (( $BUILDR_MODE == 1 )); then
        echo "Builder Mode is already running"
        return 1
    fi

    echo "🎵 Builder vibes loading..."

    # Play music and capture process ID
    mpv --no-terminal --audio-display=no "$SCRIPT_DIR/sunset-lover.mp3" &
    MUSIC_PID=$!

    cd ~/Development || return 1

    # Modify prompt (persistent)
    if ! grep -Fxq "$BUILDR_MODE_BLOCK_MARKER_START" "$BASHRC"; then
        echo -e "\n$BUILDR_MODE_BLOCK" >> "$BASHRC"
        source "$BASHRC"
    else
        echo "Builder Mode prompt is already active"
    fi

    # Change text colour
    # echo -e "\033[0;32m"  # Set text to green

    # Change system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/builder-wallpaper.jpg"

    echo "🧪 Builder Mode: Let’s build something silly and cool."

    BUILDR_MODE=1
}

# Type 'exitbuildr' to exit builder mode
exitbuildr() {

    if (( $BUILDR_MODE == 0 )); then
        echo "Builder Mode is not running"
        return 1
    fi

    echo "👋 Exiting Builder Mode."

    # Stop music
    kill "$MUSIC_PID"

    # Reset terminal prompt
    cp "$BASHRC" "$BASHRC_BAK" # Back up .bashrc before removing any lines
    sed -i "/# >>> BUILDER MODE BLOCK START >>>/,/# <<< BUILDER MODE BLOCK END <<</d" "$BASHRC"
    source "$BASHRC"

    # Reset text colour
    # echo -e "\033[0m"

    # Restore system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/default-wallpaper.jpg"

    cd || return 1
    echo "👋 Back to base: Bye!"

    BUILDR_MODE=0
}

