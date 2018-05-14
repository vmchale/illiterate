#!/usr/bin/env sh

set -e
set pipefail

getTarget() {
    if [ "$(uname)" = "Darwin" ]
    then
        echo "lit-$(uname -m)-apple-darwin"
    else
        echo "lit-$(uname -m)-unknown-linux"
    fi
}

main() {

    latest="$(curl -s https://github.com/vmchale/illiterate/releases/latest/ | cut -d'"' -f2 | rev | cut -d'/' -f1 | rev)"
    binname=$(getTarget)
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/man/man1/"
    mkdir -p "$HOME/.compleat"
    dest=$HOME/.local/bin/lit
    man_dest=$HOME/.local/share/man/man1/lit.1
    if which duma > /dev/null ; then
        duma https://github.com/vmchale/illiterate/releases/download/"$latest"/"$binname" -O "$dest"
        duma https://github.com/vmchale/illiterate/releases/download/"$latest"/lit.1 -O "$man_dest"
    else
        wget https://github.com/vmchale/illiterate/releases/download/"$latest"/"$binname" -O "$dest"
        wget https://github.com/vmchale/illiterate/releases/download/"$latest"/lit.1 -O "$man_dest"
    fi
    chmod +x "$dest"

}

main
