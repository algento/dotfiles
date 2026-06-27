#!/bin/bash
# utility scripts for installing and configuring Mac & Linux
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : script-utils.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

echo '--Check OS'
OS="$(uname -s)"
if [ "$OS" = "Linux" ]; then
    . /etc/os-release

    if [ "$ID" = "ubuntu" ]; then
        echo "Ubuntu detected!"
        OS="Ubuntu"
    else
        echo "Other Linux distro!: $ID"
    fi
elif [ "$OS" = "Darwin" ]; then
    echo "MacOS detected!"
else
    echo "Not linux or unix"
fi

echo '--Check Shell'
SHELL_NAME="$(basename "$SHELL")"
case "$SHELL_NAME" in
zsh)
    FILE="$HOME/.zshrc"
    echo "Supported shell: $SHELL_NAME"
    ;;
bash)
    FILE="$HOME/.bashrc"
    echo "Supported shell: $SHELL_NAME"
    ;;
*)
    echo "Unsupported shell: $SHELL_NAME"
    exit 1
    ;;
esac

add_line() {
    grep -qxF "$1" "$2" 2>/dev/null || echo "$1" >>"$2"
}
