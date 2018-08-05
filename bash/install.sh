#!/usr/bin/env sh

set -e
set pipefail

getTarget() {
    if [ "$(uname)" = "Darwin" ]
    then
        echo "lit-$(uname -m)-apple-darwin"
    else
        case $(uname -m) in
            "x86_64") MACHINE="unknown-linux";;
            "aarch64") MACHINE="linux-gnu";;
            "alpha") MACHINE="linux-gnu";;
            "arm") MACHINE="linux-gnueabihf";;
            "mips64"*) MACHINE="linux-gnuabi64";;
            "mips"*) MACHINE="linux-gnu";;
            "powerpc"*) MACHINE="linux-gnu";;
            "s390x") MACHINE="linux-gnu";;
            "i686") MACHINE="linux-gnu";;
        esac
        echo "lit-$(uname -m)-$MACHINE"
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

    url="https://github.com/vmchale/illiterate/releases/download/$latest/$binname"
    man_url="https://github.com/vmchale/illiterate/releases/download/$latest/lit.1"

    if command -v wget > /dev/null ; then
        wget "$url" -O "$dest"
        wget "$man_url" -O "$man_dest"
    else
        curl "$url" -o "$dest"
        curl "$man_url" -o "$man_dest"
    fi

    chmod +x "$dest"

}

main
