all:
    atspkg build target/illiterate.deb --pkg-args "./native.dhall"
    atspkg build --target=i686-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=s390x-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=arm-linux-gnueabihf --pkg-args "./gc.dhall"
    atspkg build --target=powerpc64-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=powerpc64le-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=powerpc-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=aarch64-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=alpha-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=m68k-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=mips-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=mipsel-linux-gnu --pkg-args "./gc.dhall"
    atspkg build --target=mips64-linux-gnuabi64 --pkg-args "./gc.dhall"
    atspkg build --target=mips64el-linux-gnuabi64 --pkg-args "./gc.dhall"
    atspkg build --target=x86_64-unknown-redox --pkg-args "./no-gc.dhall False"
    atspkg build --target=sh4-linux-gnu --pkg-args "./no-gc.dhall True"
    atspkg build --target=arm-linux-gnueabi --pkg-args "./no-gc.dhall True"
    atspkg build --target=riscv64-linux-gnu --pkg-args "./no-gc.dhall True"
    atspkg build --target=hppa-linux-gnu --pkg-args "./no-gc.dhall True"
    atspkg build --target=m68hc11 --pkg-args "./no-gc.dhall True"
    atspkg build --target=sparc64-linux-gnu --pkg-args "./no-gc.dhall True"
    atspkg build --target=msp430 --pkg-args "./no-gc.dhall True"

bench:
    bench "./target/lit test/data/calc.ly" "lit test/data/calc.ly"

poly:
    @poly -e data

ci:
    yamllint .travis.yml
    tomlcheck --file .atsfmt.toml

example:
    atspkg build
    ./target/lit test/data/calc.ly
    ./target/lit test/data/setup.lhs

clean:
    rm -f tags
    atspkg clean

deb:
    atspkg build target/illiterate.deb

release: all
    git tag "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    git push origin --tags
    git tag -d "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    git push origin master
    github-release release -s $(cat ~/.git-token) -u vmchale -r polyglot -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-s390x-linux-gnu -f target/poly-s390x-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-arm-linux-gnueabihf -f target/poly-arm-linux-gnueabihf -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-aarch64-linux-gnu -f target/poly-aarch64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-powerpc-linux-gnu -f target/poly-powerpc-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-powerpc64-linux-gnu -f target/poly-powerpc64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-powerpc64le-linux-gnu -f target/poly-powerpc64le-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-alpha-linux-gnu -f target/poly-alpha-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-mips-linux-gnu -f target/poly-mips-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-mipsel-linux-gnu -f target/poly-mipsel-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-mips64-linux-gnuabi64 -f target/poly-mips64-linux-gnuabi64 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-mips64el-linux-gnuabi64 -f target/poly-mips64el-linux-gnuabi64 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-x86_64-unknown-redox -f target/poly-x86_64-unknown-redox -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-sh4-linux-gnu -f target/poly-sh4-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly-arm-linux-gnuabi -f target/poly-arm-linux-gnuabi -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly.1 -f man/poly.1 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n poly.usage -f compleat/poly.usage -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r polyglot -n polyglot.deb -f target/polyglot.deb -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"


next:
    @export VERSION=$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats | awk -F. '{$NF+=1; print $0}' | sed 's/ /\./g') && echo $VERSION && sed -i "s/[0-9]\+\.[0-9]\+\.[0-9]\+\+/$VERSION/" src/cli.dats
    @git commit -am "version bump"
