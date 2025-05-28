SCRIPT_DIR="$(dirname "$BASH_SOURCE")"

BASHRC="$HOME/.bashrc"
BASHRC_BAK="$HOME/.bashrc.bak"

BUILDR_MODE_PROMPT="\[\e[1;31m\][BUILDING...]\[\e[0m\] \u@\h:\w\$ "

BUILDR_MODE_BLOCK_MARKER_START="# >>> BUILDER MODE BLOCK START >>>"
BUILDR_MODE_BLOCK_MARKER_END="# <<< BUILDER MODE BLOCK END <<<"

BUILDR_MODE_BLOCK=$(cat <<_END_OF_BLOCK_
$BUILDR_MODE_BLOCK_MARKER_START
export PS1="$BUILDR_MODE_PROMPT"
$BUILDR_MODE_BLOCK_MARKER_END
_END_OF_BLOCK_
)

_read_prompt_state() {
    local STATE_FILE="$SCRIPT_DIR/.builder-mode-state"

    [ -f "$STATE_FILE" ] && source "$STATE_FILE"

    # Use default values if unset
    : ${BUILDR_MODE:=0}
    : ${MUSIC_PID:=}
}

_play_music() {
    
    # Play music and capture process ID
    mpv --no-terminal --audio-display=no "$SCRIPT_DIR/sunset-lover.mp3" &
    MUSIC_PID=$!

    local STATE_FILE="$SCRIPT_DIR/.builder-mode-state"
    [ -f "$STATE_FILE" ] || touch "$STATE_FILE"

    if grep -q "^MUSIC_PID=" "$STATE_FILE"; then
        # Replace value
        sed -i "s|^MUSIC_PID=.*|MUSIC_PID=$MUSIC_PID|" "$STATE_FILE"
    else
        # Variable doesn't exist
        echo "MUSIC_PID=$MUSIC_PID" >> "$STATE_FILE"
    fi
}

_stop_music() {

    # Ensure PID is not empty and that an 'mpv' process with the stored PID exists
    if [[ -n "$MUSIC_PID" ]] && pgrep -l mpv | grep -q "$MUSIC_PID"; then

        kill "$MUSIC_PID"

        MUSIC_PID=""
        
    else
        echo "Music is not running"
    fi

    local STATE_FILE="$SCRIPT_DIR/.builder-mode-state"
    [ -f "$STATE_FILE" ] || touch "$STATE_FILE"

    if grep -q "^MUSIC_PID=" "$STATE_FILE"; then
        # Replace value
        sed -i "s|^MUSIC_PID=.*|MUSIC_PID=$MUSIC_PID|" "$STATE_FILE"
    else
        # Variable doesn't exist
        echo "MUSIC_PID=$MUSIC_PID" >> "$STATE_FILE"
    fi
}

_signal_builder_mode_started() {

    echo "🧪 Builder Mode: Let’s build something silly and cool."

    BUILDR_MODE=1

    local STATE_FILE="$SCRIPT_DIR/.builder-mode-state"
    [ -f "$STATE_FILE" ] || touch "$STATE_FILE"

    if grep -q "^BUILDR_MODE=" "$STATE_FILE"; then
        # Replace value
        sed -i "s|^BUILDR_MODE=.*|BUILDR_MODE=$BUILDR_MODE|" "$STATE_FILE"
    else
        # Variable doesn't exist
        echo "BUILDR_MODE=$BUILDR_MODE" >> "$STATE_FILE"
    fi
}

_signal_builder_mode_stopped() {

    echo "👋 Back to base: Bye!"
    
    BUILDR_MODE=0

    local STATE_FILE="$SCRIPT_DIR/.builder-mode-state"
    [ -f "$STATE_FILE" ] || touch "$STATE_FILE"

    if grep -q "^BUILDR_MODE=" "$STATE_FILE"; then
        # Replace value
        sed -i "s|^BUILDR_MODE=.*|BUILDR_MODE=$BUILDR_MODE|" "$STATE_FILE"
    else
        # Variable doesn't exist
        echo "BUILDR_MODE=$BUILDR_MODE" >> "$STATE_FILE"
    fi
}

# Type 'buildr' to enter builder mode
buildr() {

    _read_prompt_state

    if (( $BUILDR_MODE == 1 )); then
        echo "Builder Mode is already running"
        return 1
    fi

    echo "🎵 Builder vibes loading..."

    _play_music

    _read_prompt_state

    cd ~/Development || return 1

    # Modify prompt (persistent)
    if ! grep -Fxq "$BUILDR_MODE_BLOCK_MARKER_START" "$BASHRC"; then
        echo -e "\n\n$BUILDR_MODE_BLOCK" >> "$BASHRC"
        source "$BASHRC"
    else
        echo "Builder Mode prompt is already active"
    fi

    # Change text colour
    # echo -e "\033[0;32m"  # Set text to green

    # Change system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/builder-wallpaper.jpg"

    _signal_builder_mode_started
}

# Type 'exitbuildr' to exit builder mode
exitbuildr() {

    _read_prompt_state

    if (( $BUILDR_MODE == 0 )); then
        echo "Builder Mode is not running"
        return 1
    fi

    echo "👋 Exiting Builder Mode."

    _stop_music

    # Reset terminal prompt
    cp "$BASHRC" "$BASHRC_BAK" # Back up .bashrc before removing any lines
    sed -i "/# >>> BUILDER MODE BLOCK START >>>/,/# <<< BUILDER MODE BLOCK END <<</d" "$BASHRC"

    # Remove any trailing blank lines in .bashrc
    tmp=$(mktemp)
    tac "$BASHRC" | sed '/\S/,$!d' | tac > "$tmp" && mv "$tmp" "$BASHRC"

    source "$BASHRC"

    # Reset text colour
    # echo -e "\033[0m"

    # Restore system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/default-wallpaper.jpg"

    cd || return 1

    _signal_builder_mode_stopped
}

