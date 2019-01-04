{- Imports -}
let prelude = http://hackage.haskell.org/package/ats-pkg/src/dhall/atspkg-prelude.dhall
in

let not = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Bool/not
in

{- Helpers -}
let ccopts = [ "-flto" ]
in

let man = [ "man/lit.1" ]
  : Optional Text
in

λ(cfg : { gc : Bool, pthread : Bool, static : Bool, cross : Bool }) →
    let staticFlag =
        if cfg.static
            then [ "-static" ]
            else ([] : List Text)
    in
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
        , clib = if cfg.static
          then [ prelude.upperDeps { name = "gc", version = [7,6,8] } ]
          else prelude.mapPlainDeps ([] : List Text)
        , cflags = ccopts # [ "-O2" ] # staticFlag # (if not cfg.cross then [ "-mtune=native" ] else ([] : List Text))
        , debPkg = prelude.mkDeb
            (prelude.debian "illiterate" ⫽
                { version = [0,1,1]
                , maintainer = "Vanessa McHale <vamchale@gmail.com>"
                , description = "Literate programming preprocessor"
                , manpage = man
                , binaries = [ "${prelude.atsProject}/lit" ]
                })
    }
