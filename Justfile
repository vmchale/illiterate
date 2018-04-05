example:
    mkdir -p test/data
    duma https://raw.githubusercontent.com/simonmar/happy/master/examples/Calc.ly -O test/data/calc.ly
    atspkg build
    ./target/lit test/data/calc.ly

clean:
    atspkg clean
    rm -rf test/data tags
