#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

staload "prelude/SATS/filebas.sats"
staload "libats/ML/SATS/filebas.sats"
staload UN = "prelude/SATS/unsafe.sats"

fun is_good(x : string) : bool =
  let
    val head = string_make_substring(x, i2sz(0), i2sz(2))
  in
    head = "> "
  end

fun version() : void =
  println!("illiterate version 0.1.0\nCopyright (c) 2018 Vanessa McHale")

fun help() : void =
  print("lit - A literate programming preprocessor.
\33[36mUSAGE:\33[0m lit LITERATE PLAIN
\33[36mFLAGS:\33[0m
    -V, --version            show version information
    -h, --help               display this help and exit
    
    Bug reports and updates: github.com/vmchale/illiterate\n")

fun as_sub(x : string) : string =
  let
    val l = length(x)
  in
    string_make_substring(x, i2sz(2), l)
  end

fun as_string(x : stream_vt(string)) : string =
  let
    fun loop(x : stream_vt(string)) : string =
      case+ !x of
        | ~stream_vt_nil() => ""
        | ~stream_vt_cons (y, ys) => y + "\n" + loop(ys)
  in
    loop(x)
  end

// TODO figure out how tf to write inner loop?
// val (pf | file_ptr) = popen(in_file, $UN.cast("r"))
// val _ = pclose1_exn(pf | file_ptr)
// usage: lit INPUT OUTPUT
// defaulting to stdio/stdout
fun bird_process(in_file : string) : string =
  let
    val file_ref = fileref_open_exn(in_file, file_mode_r)
    val file_stream = streamize_fileref_line(file_ref)
    val filter_stream = stream_vt_filter_cloptr( file_stream
                                               , lam x =<cloptr1> is_good(x)
                                               )
    val map_stream = stream_vt_map_cloptr( filter_stream
                                         , lam x =<cloptr1> as_sub(x)
                                         )
    val ret = as_string(map_stream)
  in
    ret
  end

fun print_error() : void =
  {
    val _ = prerrln!("\33[31mError:\33[0m: No input file supplied")
    val _ = exit(1)
  }

// set type by flags?
// TODO allow to standard input?
// stdin_ref should work.
implement main0 (argc, argv) =
  {
    val x = if argc > 1 then
      argv[1]
    else
      (print_error() ; "")
    val s = bird_process(x)
    val _ = println!(s)
  }
