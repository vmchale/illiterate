#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

staload "prelude/SATS/filebas.sats"
staload "libats/ML/SATS/filebas.sats"
staload UN = "prelude/SATS/unsafe.sats"

#include "src/cli.dats"

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

fun bird_process(in_file : string) : string =
  let
    val file_ref = fileref_open_exn(in_file, file_mode_r)
    val file_stream = streamize_fileref_line(file_ref)
    val ret_stream = loop_process(file_stream, false)
  in
    as_string(ret_stream)
  end

fun error(s : string) : void =
  {
    val _ = prerrln!("\33[31mError:\33[0m: " + s)
    val _ = exit(1)
  }

fun is_flag(s : string) : bool =
  string_is_prefix("-", s)

// set type by flags?
// TODO allow to standard input?
// stdin_ref should work.
implement main0 (argc, argv) =
  {
    val x = if argc > 1 then
      argv[1]
    else
      (error("No file supplied.") ; "")
    val s = bird_process(x)
    val _ = println!(s)
  }
