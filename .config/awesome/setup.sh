#!/bin/sh

case $1 in
    awesome-wm-pacman-setup)
        echo "installing awesome wm essentials"

        sudo pacman -Syu awesome xcompmgr nm-applet flameshot mc pamixer nvim emacs git curl alacritty xorg-xbacklight acpi tlp tlp-rdw firefox
        ;;
    spacevim-setup)
        echo "installing spacevim"

        curl -sLf https://spacevim.org/install.sh | bash
        ;;
    doomemacs-setup)
        echo "installing doomemacs"

        git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
        ~/.emacs.d/bin/doom install
        ;;
    *)
        echo "no argument..."
        ;;
esac

echo "done."
