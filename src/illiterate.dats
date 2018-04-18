#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

staload "prelude/SATS/filebas.sats"
staload ML = "libats/ML/SATS/filebas.sats"
staload "libats/libc/SATS/stdio.sats"
staload UN = "prelude/SATS/unsafe.sats"

#include "src/cli.dats"

// TODO figure out how to read into a buffer, etc.
(*
fn no_gc_stream(s : string) : stream_vt(Strptr1) =
  let
    var x: FILEptr1 = fopen_exn(s, file_mode_r)
  in
    streamize_fileptr_line($UN.castvwtp0(x))
  end
*)
fun is_good(x : string) : bool =
  let
    var head = string_make_substring(x, i2sz(0), i2sz(2))
  in
    head = "> "
  end

fun as_sub(x : string) : string =
  let
    var l = length(x)
  in
    string_make_substring(x, i2sz(2), l)
  end

fun as_string(x : stream_vt(string)) : string =
  let
    fun loop(x : stream_vt(string)) : string =
      case+ !x of
        | ~stream_vt_nil() => ""
        | ~stream_vt_cons (y, ys) => let
          var z = loop(ys)
        in
          if z != "" then
            y + "\n" + z
          else
            y
        end
  in
    loop(x)
  end

fun loop_process(x : stream_vt(string), code_block : bool) : stream_vt(string) =
  case+ !x of
    | ~stream_vt_cons ("\\begin{code}", xs) when not(code_block) => loop_process(xs, true)
    | ~stream_vt_cons ("\\end{code}", xs) when code_block => loop_process(xs, false)
    | ~stream_vt_cons (x, xs) when code_block => 
      begin
        let
          val ys = loop_process(xs, code_block)
        in
          $ldelay(stream_vt_cons(x, ys), ~ys)
        end
      end
    | ~stream_vt_cons (x, xs) when is_good(x) => 
      begin
        let
          val ys = loop_process(xs, code_block)
        in
          $ldelay(stream_vt_cons(as_sub(x), ys), ~ys)
        end
      end
    | ~stream_vt_cons (x, xs) => loop_process(xs, code_block)
    | ~stream_vt_nil() => $ldelay(stream_vt_nil)

fun process(in_file : string) : string =
  let
    var file_ref = fileref_open_exn(in_file, file_mode_r)
    var file_stream = $ML.streamize_fileref_line(file_ref)
    var ret_stream = loop_process(file_stream, false)
  in
    as_string(ret_stream)
  end

// set type by flags?
// TODO allow to standard input?
// stdin_ref should work.
implement main0 (argc, argv) =
  {
    val cfg = get_cli(argc, argv, 0, empty_config)
    val _ = if cfg.should_help then
      help()
    val _ = if cfg.version then
      version()
    val x0 = cfg.input_f
    val x = if x0 != "þ" then
      x0
    else
      (fail("no input file given.") ; "")
    var s = process(x)
    val _ = println!(s)
  }
