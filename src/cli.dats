typedef cli_config = @{ should_help = bool, version = bool, input_f = string }

fun is_flag(s : string) : bool =
  string_is_prefix("-", s)

val empty_config = @{ should_help = false, version = false, input_f = "þ" }

fun fail(s : string) : void =
  {
    val _ = prerrln!("\33[31mError:\33[0m " + s)
    val _ = exit(1)
  }

fun version() : void =
  {
    val _ = println!("illiterate version 0.1.0\nCopyright (c) 2018 Vanessa McHale")
    val _ = exit(0)
  }

fun help() : void =
  {
    val _ = print("lit - A literate programming preprocessor.
\33[36mUSAGE:\33[0m lit FILE FLAGS ...
\33[36mFLAGS:\33[0m
    -v, --version            show version information
    -h, --help               display this help and exit

    Bug reports and updates: github.com/vmchale/illiterate\n")
    val _ = exit(0)
  }

fun process(arg : string, acc : cli_config, is_zero : bool) : cli_config =
  let
    var acc_r = ref<cli_config>(acc)
    val _ = ifcase
      | arg = "--help" || arg = "-h" => acc_r -> should_help := true
      | arg = "--version" || arg = "-v" => acc_r -> version := true
      | is_flag(arg) => fail("command-line flag not recognized: " + arg)
      | is_zero => ()
      | acc.input_f = "þ" => acc_r -> input_f := arg
      | _ => fail("more than one input file.")
  in
    !acc_r
  end

fun get_cli { n : int | n >= 1 }{ m : nat | m < n } .<n-m>. (argc : int(n), argv : !argv(n), current : int(m), acc : cli_config) :
  cli_config =
  let
    var arg = argv[current]
    val cfg = process(arg, acc, current = 0)
  in
    if current < argc - 1 then
      get_cli(argc, argv, current + 1, cfg)
    else
      cfg
  end
