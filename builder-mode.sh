#!/bin/bash

# Type 'buildr' to enter builder mode
buildr() {

    echo "🎵 Builder vibes loading..."
    cd ~/Development || return 1

    # Play music
    mpv --no-terminal sunset-lover.mp3 &

    # Modify prompt and change text colour
    # export PS1="[\[\033[01;32m\]BUILDR MODE\[\033[00m\]] \u@\h:\w\$ "
    # echo -e "\033[0;32m"  # Set text to green

    # Change system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/builder-wallpaper.jpg"

    echo "🧪 Builder Mode: Let’s build something silly and cool."
}

# Type 'exitbuildr' to exit builder mode
exitbuildr() {

    echo "👋 Exiting Builder Mode."

    # Stop music
    # pkill mpv

    # Reset terminal prompt and text colour
    # export PS1="\u@\h:\w\$ "
    # echo -e "\033[0m"  # Reset text color

    # Restore system wallpaper
    # gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/wallpapers/default-wallpaper.jpg"

    cd || return 1
    echo "👋 Back to base: Bye!"
}

