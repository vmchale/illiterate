{- Imports -}
let prelude = https://raw.githubusercontent.com/vmchale/atspkg/master/ats-pkg/dhall/atspkg-prelude.dhall sha256:33e41e509b6cfd0b075d1a8a5210ddfd1919372f9d972c2da783c6187d2298ba

let not = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Bool/not sha256:723df402df24377d8a853afed08d9d69a0a6d86e2e5b2bac8960b0d4756c7dc4
in

{- Helpers -}
let ccopts = [ "-flto" ]

let man = Some "man/lit.1"
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
        , man = Some "man/lit.md"
        , clib = if cfg.static
          then [ prelude.upperDeps { name = "gc", version = [7,6,8] } ]
          else prelude.mapPlainDeps ([] : List Text)
        , cflags = ccopts # [ "-O2" ] # staticFlag # (if not cfg.cross then [ "-mtune=native" ] else ([] : List Text))
        , debPkg = prelude.mkDeb
            (prelude.debian "illiterate" ⫽
                { version = [0,1,2]
                , maintainer = "Vanessa McHale <vamchale@gmail.com>"
                , description = "Literate programming preprocessor"
                , manpage = man
                , binaries = [ "${prelude.atsProject}/lit" ]
                })
    }
