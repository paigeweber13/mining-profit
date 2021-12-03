module Analysis

include("DBTools.jl")

using Dates
using Plots
using Printf
using SQLite

TABLE_NAME = "mining_stats"
DATETIME_FORMATSTRING = "YYYY-mm-dd HH:MM:SS"
POOLS = ["miningpoolhub" "ezil" "flexpool"]

function calculateprofitperhash(db, pool::String, time_start::Dates.DateTime, 
        time_end::Dates.DateTime)

    qs = @sprintf("""
        SELECT hashrate, balance 
        FROM %s 
        WHERE pool = '%s' 
        AND datetime >= '%s' 
        AND datetime < '%s'""", 
        TABLE_NAME, pool,
        Dates.format(time_start, DATETIME_FORMATSTRING), 
        Dates.format(time_end, DATETIME_FORMATSTRING))

    BAD_DATA_EXIT_CODE = -1.0

    result = DBInterface.execute(db, qs)

    profitperhash = BAD_DATA_EXIT_CODE
    balance_initial = -1.0
    balance_final = 0.0
    cum_hashrate = 0.0
    num_rows = 0

    for row in result
        if row.balance < 0
            return BAD_DATA_EXIT_CODE
        end

        num_rows += 1
        cum_hashrate += row.hashrate

        # only execute on first pass
        if balance_initial == -1.0
            balance_initial = row.balance
        end

        # execute every pass to keep last value
        balance_final = row.balance
    end


    avg_hashrate = cum_hashrate / num_rows
    balance_change = balance_final - balance_initial
    profitperhash = balance_change / avg_hashrate

    return profitperhash
end

function gatherprofithistory(db)
    qs = @sprintf("SELECT MIN(datetime) FROM %s", TABLE_NAME)
    result = DBInterface.execute(db, qs)
    startdate = missing

    for row in result
        startdate = getproperty(row, Symbol("MIN(datetime)"))
        startdate = Dates.DateTime(startdate, DATETIME_FORMATSTRING)
    end

    profithistory = Dict()   
    profithistory["datetime"] = []
    for pool in POOLS
        profithistory[pool] = []
    end

    enddate = startdate + Dates.Hour(6)
    while enddate < Dates.now()
        push!(profithistory["datetime"], enddate)

        for pool in POOLS
            profitpermegahash = calculateprofitperhash(db, pool, startdate, 
                enddate) * 1e6
            
            if profitpermegahash < 0 || isnan(profitpermegahash)
                profitpermegahash = missing
            end

            push!(profithistory[pool], profitpermegahash)
        end

        startdate = enddate
        enddate = startdate + Dates.Hour(6)
    end

    return profithistory
end

function graphprofitovertime(profithistory)
    # operate in headless mode:
    ENV["GKSwstype"] = "100"

    x = profithistory["datetime"]
    y = Array{Union{Missing, Array{Union{Missing, Float64}}}}(
        missing, length(POOLS))

    for i = 1:length(POOLS)
        y[i] = profithistory[POOLS[i]]
    end

    plot(x, y, title = "Ethereum mining pool profitability comparison",
        label = POOLS, lw = 2, size = (1500, 700))
    
    savefig("profitgraph.png")
end

function countwinsperpool(profithistory)
    winsperpool = Dict()
    for pool in POOLS
        winsperpool[pool] = 0
    end

    for i = 1:length(profithistory["datetime"])
        currentwinner = ""
        currentwinningprofit = 0.0

        for pool in POOLS
            if ismissing(profithistory[pool][i])
                continue
            end

            if profithistory[pool][i] > currentwinningprofit
                currentwinner = pool
            end
        end

        winsperpool[currentwinner] += 1
    end

    winsperpool
end

function getaveragepoolprofitability(profithistory)
    avgprofitability = Dict()
    for pool in POOLS
        totalprofit = 0.0

        for profit in profithistory[pool]
            if !ismissing(profit)
                totalprofit += profit
            end
        end

        avgprofit = totalprofit / length(profithistory[pool])
        avgprofitability[pool] = avgprofit
    end

    avgprofitability
end

end # module
