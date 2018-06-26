all:
    atspkg build --target=s390x-linux-gnu
    atspkg build --target=arm-linux-gnueabihf
    atspkg build --target=powerpc64-linux-gnu
    atspkg build --target=powerpc64le-linux-gnu
    atspkg build --target=powerpc-linux-gnu
    atspkg build --target=aarch64-linux-gnu
    atspkg build --target=alpha-linux-gnu
    atspkg build --target=m68k-linux-gnu
    atspkg build --target=mips-linux-gnu
    atspkg build --target=mipsel-linux-gnu
    atspkg build --target=mips64-linux-gnuabi64
    atspkg build --target=mips64el-linux-gnuabi64

release:
    git tag "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    git push origin --tags
    git tag -d "$(grep -P -o '\d+\.\d+\.\d+' src/cli.dats)"
    git push origin master

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
