poly:
    poly -e data

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
