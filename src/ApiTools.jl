module ApiTools

using HTTP
using JSON
using Printf
using URIs

const SCHEME = "https"

const MININGPOOLHUB_HOST = "ethereum.miningpoolhub.com"
const MININGPOOLHUB_PATH = "/index.php"

const FLEXPOOL_HOST = "api.flexpool.io"
const FLEXPOOL_PATH_START = "/v2"

function miningpoolhub_getbalance(apikey::String)
    query_miningpoolhub_balance = Dict([("page", "api"), 
        ("action", "getuserbalance"), ("api_key", apikey)])
    url_getbalance = URIs.URI(scheme=SCHEME, host=MININGPOOLHUB_HOST,
        path=MININGPOOLHUB_PATH, query=query_miningpoolhub_balance)
    # "https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserbalance"
    
    r = HTTP.get(url_getbalance)
    # println("Response: ", String(r.body))
    response_json = JSON.parse(String(r.body))
    return response_json["getuserbalance"]["data"]
end

function miningpoolhub_gethashrate(apikey::String)
    query_miningpoolhub_hashrate = Dict([("page", "api"), 
        ("action", "getuserhashrate"), ("api_key", apikey)])
    url_gethashrate = URIs.URI(scheme=SCHEME, host=MININGPOOLHUB_HOST,
        path=MININGPOOLHUB_PATH, query=query_miningpoolhub_hashrate)
    
    r = HTTP.get(url_gethashrate)
    response_json = JSON.parse(String(r.body))
    return response_json["getuserhashrate"]["data"]
end

function ezil_getbalance(combinedwallet_str)
    ezil_billing_host = "billing.ezil.me"
    ezil_balance_path = @sprintf("/balances/%s", combinedwallet_str)

    url_getbalance = URIs.URI(scheme=SCHEME, host=ezil_billing_host,
        path=ezil_balance_path)
    
    r = HTTP.get(url_getbalance)
    response_json = JSON.parse(String(r.body))
    return response_json["eth"]
end

function ezil_gethashrate(combinedwallet_str)
    ezil_stats_host = "stats.ezil.me"
    ezil_hashrate_path = @sprintf("/current_stats/%s/reported", 
        combinedwallet_str)

    url_gethashrate = URIs.URI(scheme=SCHEME, host=ezil_stats_host,
        path=ezil_hashrate_path)
    
    r = HTTP.get(url_gethashrate)
    response_json = JSON.parse(String(r.body))
    return response_json["eth"]["current_hashrate"]
end

function flexpool_getbalance(wallet)
    # for some reason, flexpool reports the balance as an integer in increments
    # of 1e-18 eth. So in their API, 1e18 == 1 eth
    flexpool_conversion_rate = 1e-18

    flexpool_balance_path = @sprintf("%s/miner/balance", FLEXPOOL_PATH_START)
    query_flexpool_balance = Dict([("coin", "eth"), ("address", wallet)])

    url_getbalance = URIs.URI(scheme=SCHEME, host=FLEXPOOL_HOST,
        path=flexpool_balance_path, query=query_flexpool_balance)
    
    r = HTTP.get(url_getbalance)
    response_json = JSON.parse(String(r.body))
    return response_json["result"]["balance"] * flexpool_conversion_rate
end

function flexpool_gethashrate(wallet)
    flexpool_hashrate_path = @sprintf("%s/miner/stats", FLEXPOOL_PATH_START)
    query_flexpool_hashrate = Dict([("coin", "eth"), ("address", wallet)])

    url_gethashrate = URIs.URI(scheme=SCHEME, host=FLEXPOOL_HOST,
        path=flexpool_hashrate_path, query=query_flexpool_hashrate)
    
    r = HTTP.get(url_gethashrate)
    response_json = JSON.parse(String(r.body))
    return response_json["result"]["currentEffectiveHashrate"]
end

end # module
