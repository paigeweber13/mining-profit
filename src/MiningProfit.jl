module MiningProfit

include("ApiTools.jl")
include("Config.jl")
include("DBTools.jl")

using Dates

function updateallstats() 
    cfg = Config.loadconfig()

    # miningpoolhub
    datestring = Dates.format(Dates.now(), "YYYY-mm-dd_HHMM")
    mph_balance = ApiTools.miningpoolhub_getbalance(cfg["miningpoolhub"]["apikey"])
    mph_hashrate = ApiTools.miningpoolhub_gethashrate(cfg["miningpoolhub"]["apikey"])
    DBTools.insertminingdata("miningpoolhub", datestring, mph_hashrate, 
      mph_balance["confirmed"])
end

end # module
