using Pkg
Pkg.activate(".")

# third-party imports
using ArgParse

# first-party imports
using MiningProfit

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--get-stats", "-s"
            help = "Get current balance and hashrate for all configured pools and store it to the local sqlite database."
            action = :store_true
        "--analyze-profit", "-p"
            help = "Analyze data gathered by 'get-stats' to plot profitability statistics and calculate average profitability of pools."
            action = :store_true
        # "--opt1"
        #     help = "an option with an argument"
        # "--opt2", "-o"
        #     help = "another option with an argument"
        #     arg_type = Int
        #     default = 0
        # "--flag1"
        #     help = "an option without argument, i.e. a flag"
        #     action = :store_true
        # "arg1"
        #     help = "a positional argument"
        #     required = true
    end

    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()

    if parsed_args["get-stats"]
        MiningProfit.updateallstats()
    end
    if parsed_args["analyze-profit"]
        MiningProfit.analyzeprofit()
    end
end

main()
