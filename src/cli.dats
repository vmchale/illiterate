typedef cli_config = @{ should_help = bool, version = bool, input_f = string, output_f = FILEref }

fun version() : void =
  println!("illiterate version 0.1.0\nCopyright (c) 2018 Vanessa McHale")

fun help() : void =
  {
    val _ = print("lit - A literate programming preprocessor.
\33[36mUSAGE:\33[0m lit FILE FLAGS ...
\33[36mFLAGS:\33[0m
    -V, --version            show version information
    -h, --help               display this help and exit
    -o, --output             set a file for output

    If no output file is set, the generated source code will
    be printed to the terminal.
    
    Bug reports and updates: github.com/vmchale/illiterate\n")
    val _ = exit(0)
  }

fun get_cli { n : int | n >= 1 }{ m : nat | m < n } .<n-m>. ( argc : int(n)
                                                            , argv : !argv(n)
                                                            , current : int(m)
                                                            , prev_is_output : bool
                                                            , acc : cli_config
                                                            ) : cli_config =
  let
    var arg = argv[current]
  in
    acc
  end
