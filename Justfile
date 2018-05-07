target TARGET:
    atspkg clean ; atspkg nuke ; atspkg build --target={{ TARGET }}
    mv target/lit target/lit-{{ TARGET }}

# hppa-linux-gnu, arm-linux-gnueabihf, sh4-linux-gnu, aarch-linux-gnu, m68k-linux-gnu, arm-linux-gnueabi
# tried: powerpc64-linux-gnu, s390x-linux-gnu, alpha-linux-gnu, h8300-hms, msp430, m68hc1x, x86_64-w64-mingw32, sparc64-linux-gnu, mips64-linux-gnuabi64, mips-linux-gnu, powerpc-linux-gnu, x86_64-unknown-redox

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
