let prelude = https://raw.githubusercontent.com/vmchale/atspkg/master/ats-pkg/dhall/atspkg-prelude.dhall

in prelude.default //
  { bin = 
    [ prelude.bin //
      { src = "src/illiterate.dats"
      , target = "target/lit"
      , gcBin = True
      }
    ]
  , compiler = [0,3,10]
  }
