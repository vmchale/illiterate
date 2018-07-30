{- Imports -}
let prelude = http://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall
in

let not = https://hackage.haskell.org/package/dhall/src/Prelude/Bool/not
in

{- Helpers -}
let ccopts = [ "-flto" ]
in

let man = [ "man/lit.1" ]
  : Optional Text
in

λ(cfg : { gc : Bool, pthread : Bool, cross : Bool }) →
    prelude.default ⫽
        { bin =
            [ prelude.bin ⫽
                { src = "src/illiterate.dats"
                , target = "${prelude.atsProject}/lit"
                , gcBin = cfg.gc
                , libs = if cfg.pthread
                    then
                        [ "pthread" ] : List Text
                    else
                        [] : List Text
                }
            ]
        , ccompiler = if cfg.cross then "cc" else "clang"
        , man = [ "man/lit.md" ] : Optional Text
        , cflags = ccopts # [ "-O2" ] # (if not cfg.cross then [ "-mtune=native" ] else ([] : List Text))
        , debPkg = prelude.mkDeb
            (prelude.debian "illiterate" ⫽
                { version = [0,1,1]
                , maintainer = "Vanessa McHale <vamchale@gmail.com>"
                , description = "Literate programming preprocessor"
                , manpage = man
                , binaries = [ "${prelude.atsProject}/lit" ]
                })
    }
