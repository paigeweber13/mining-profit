module MiningProfit

include("Analysis.jl")
include("ApiTools.jl")
include("Config.jl")
include("DBTools.jl")

using Dates

const KH_TO_MH = 1000

function updateallstats() 
    cfg = Config.loadconfig()
    db = DBTools.loadorcreatedb()

    # miningpoolhub
    datestring = Dates.format(Dates.now(), DBTools.DATETIME_FORMATSTRING)
    mph_balance = ApiTools.miningpoolhub_getbalance(
        cfg["miningpoolhub"]["apikey"])
    mph_hashrate = ApiTools.miningpoolhub_gethashrate(
        cfg["miningpoolhub"]["apikey"]) * KH_TO_MH
    DBTools.insertminingdata(db, "miningpoolhub", datestring, mph_hashrate, 
      mph_balance["confirmed"])

    # ezil
    ezil_balance = ApiTools.ezil_getbalance(cfg["ezil"]["combinedwallet"])
    ezil_hashrate = ApiTools.ezil_gethashrate(cfg["ezil"]["combinedwallet"])
    DBTools.insertminingdata(db, "ezil", datestring, ezil_hashrate, ezil_balance)

    # flexpool
    flexpool_balance = ApiTools.flexpool_getbalance( cfg["flexpool"]["wallet"])
    flexpool_hashrate = ApiTools.flexpool_gethashrate(
        cfg["flexpool"]["wallet"])
    DBTools.insertminingdata(db, "flexpool", datestring, flexpool_hashrate, 
        flexpool_balance)
end

function analyzeprofit()
    # WIP: this is currently just a demo for how "getdata" can be used. The
    # intention is for this function to eventually call 
    # Analysis.jl:calculateprofitperhash with the data gained from getdata
    db = DBTools.loadorcreatedb()

    return DBTools.getdata(db, "ezil", Dates.DateTime(2021, 09, 24, 14), 
      Dates.DateTime(2021, 09, 24, 15))
end

end # module
