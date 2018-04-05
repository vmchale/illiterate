typedef cli_config = @{ should_help = bool
                      , version = bool
                      , input_f = string
                      , output_f = string
                      }

fun get_cli { n : int | n >= 1 }{ m : nat | m < n } .<n-m>.
(argc : int(n), argv : !argv(n), current : int(m), acc : cli_config) :
  cli_config =
  let
    var arg = argv[current]
  in
    acc
  end
