{- Imports -}
let prelude = https://raw.githubusercontent.com/vmchale/atspkg/master/ats-pkg/dhall/atspkg-prelude.dhall
in

let not = https://ipfs.io/ipfs/QmdtKd5Q7tebdo6rXfZed4kN6DXmErRQHJ4PsNCtca9GbB/Prelude/Bool/not
in

{- Configuration -}
let cross = True
in

{- Helpers -}
let ccopts = [ "-flto" ]
in

let man = [ "man/lit.1" ]
  : Optional Text
in

{- Main -}
prelude.default ⫽
  { bin =
    [ prelude.bin ⫽
      { src = "src/illiterate.dats"
      , target = "target/lit"
      , gcBin = True
      , libs = if cross
          then
            [ "pthread" ] : List Text
          else
            [] : List Text
      }
    ]
  , compiler = [0,3,10]
  , man = [ "man/lit.md" ] : Optional Text
  , cflags = ccopts # [ "-O2" ] # (if not cross then [ "-mtune=native" ] else ([] : List Text))
  , debPkg = prelude.mkDeb
      (prelude.debian "illiterate" ⫽
        { version = [0,1,0]
        , maintainer = "Vanessa McHale <vamchale@gmail.com>"
        , description = "Literate programming preprocessor"
        , manpage = man
        , binaries = [ "target/lit" ]
        })
  }
