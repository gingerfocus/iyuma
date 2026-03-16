#!/bin/sh

help() {
    echo "Imager: Help"
    echo "q - quit"
    echo "h - help"
    echo "p - print file name"
    echo "d - move file to del/"
}

filepaths="$(find pix | tail -n +2 | shuf | tr ' ' '\n')"
index=0

f=""

getpath() {
    index=$((index + 1))
    f=$(echo "$filepaths" | tail -n +$index | head -n 1)
}

shownext() {
    getpath
    imv-msg $id open $f
    imv-msg $id next 1
}

getpath

imv $f &
id=$!

help

while :
do
    read l
    case "$l" in
    "q")
        imv-msg $id quit
        exit 0
        ;;
    "p")
        echo $f
        ;;
    "h")
        help
        ;;
    "d")
        mkdir -p del
        echo "moving file to del folder"
        mv "$f" del/
        shownext
        ;;
    "")
        shownext
        ;;
    *)
        echo "unknown command ($l)"
    esac
done

