let prelude = https://raw.githubusercontent.com/vmchale/atspkg/master/ats-pkg/dhall/atspkg-prelude.dhall
in

let cross = True
in

prelude.default ⫽
  { bin =
    [ prelude.bin ⫽
      { src = "src/illiterate.dats"
      , target = "target/lit"
      , gcBin = True
      }
    ]
  , compiler = [0,3,10]
  , man = [ "man/poly.md" ] : Optional Text
  , cflags = [ "-flto", "-O2" ] # (if not cross then [ "-mtune=native" ] else ([] : List Text))
  }
