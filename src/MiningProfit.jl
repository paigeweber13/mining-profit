module MiningProfit

include("ApiTools.jl")
include("Config.jl")
include("DBTools.jl")

using Dates

const KH_TO_MH = 1000

function updateallstats() 
    cfg = Config.loadconfig()

    # miningpoolhub
    datestring = Dates.format(Dates.now(), "YYYY-mm-dd_HHMM")
    mph_balance = ApiTools.miningpoolhub_getbalance(
        cfg["miningpoolhub"]["apikey"])
    mph_hashrate = ApiTools.miningpoolhub_gethashrate(
        cfg["miningpoolhub"]["apikey"]) * KH_TO_MH
    DBTools.insertminingdata("miningpoolhub", datestring, mph_hashrate, 
      mph_balance["confirmed"])

    # ezil
    ezil_balance = ApiTools.ezil_getbalance(cfg["ezil"]["combinedwallet"])
    ezil_hashrate = ApiTools.ezil_gethashrate(cfg["ezil"]["combinedwallet"])
    DBTools.insertminingdata("ezil", datestring, ezil_hashrate, ezil_balance)
end

end # module
