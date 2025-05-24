MUSIC_PID=""

PS1_ORIGINAL=""

SCRIPT_DIR="$(dirname "$BASH_SOURCE")"

BUILDR_MODE=0

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

    # Modify prompt
    PS1_ORIGINAL="$PS1"
    export PS1="\[\e[1;31m\][BUILDING...]\[\e[0m\] \u@\h:\w\$ "

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
    export PS1="$PS1_ORIGINAL"

    # Reset text colour
    # echo -e "\033[0m"

    # Restore system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/default-wallpaper.jpg"

    cd || return 1
    echo "👋 Back to base: Bye!"

    BUILDR_MODE=0
}

