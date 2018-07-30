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
    atspkg build --target=sparc64-linux-gnu --pkg-args "./no-gc.dhall True"

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
    github-release release -s $(cat ~/.git-token) -u vmchale -r illiterate -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-s390x-linux-gnu -f target/lit-s390x-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-arm-linux-gnueabihf -f target/lit-arm-linux-gnueabihf -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-aarch64-linux-gnu -f target/lit-aarch64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-powerpc-linux-gnu -f target/lit-powerpc-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-powerpc64-linux-gnu -f target/lit-powerpc64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-powerpc64le-linux-gnu -f target/lit-powerpc64le-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-alpha-linux-gnu -f target/lit-alpha-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-mips-linux-gnu -f target/lit-mips-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-mipsel-linux-gnu -f target/lit-mipsel-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-mips64-linux-gnuabi64 -f target/lit-mips64-linux-gnuabi64 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-mips64el-linux-gnuabi64 -f target/lit-mips64el-linux-gnuabi64 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-x86_64-unknown-redox -f target/lit-x86_64-unknown-redox -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-sh4-linux-gnu -f target/lit-sh4-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-arm-linux-gnuabi -f target/lit-arm-linux-gnuabi -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-riscv64-linux-gnu -f target/lit-riscv64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-hppa-linux-gnu -f target/lit-hppa-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit-sparc64-linux-gnu -f target/lit-sparc64-linux-gnu -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n lit.1 -f man/illiterate.1 -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    github-release upload -s $(cat ~/.git-token) -u vmchale -r illiterate -n illiterate.deb -f target/illiterate.deb -t "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"


next:
    @export VERSION=$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats | awk -F. '{$NF+=1; print $0}' | sed 's/ /\./g') && echo $VERSION && sed -i "s/[0-9]\+\.[0-9]\+\.[0-9]\+\+/$VERSION/" src/cli.dats
    @git commit -am "version bump"
