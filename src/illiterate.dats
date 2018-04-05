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

// val (pf | file_ptr) = popen(in_file, $UN.cast("r"))
// val _ = pclose1_exn(pf | file_ptr)
// TODO figure out how tf to write inner loop?
// usage: lit INPUT OUTPUT
// defaulting to stdio/stdout
fun make_illiterate(in_file : string) : string =
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

// TODO allow to pass standard input?
implement main0 (argc, argv) =
  {
    val x = if argc > 1 then
      argv[1]
    else
      (print_error() ; "")
    val s = make_illiterate(x)
    val _ = println!(s)
  }
