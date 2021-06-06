module MiningProfit

include("ApiTools.jl")
include("Config.jl")


function updateallstats() 
    cfg = Config.loadconfig()
    mph_stats = ApiTools.miningpoolhub_getbalance(cfg["miningpoolhub"]["apikey"])
    println(mph_stats)
end

end # module
