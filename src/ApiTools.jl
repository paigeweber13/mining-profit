module ApiTools

using HTTP
using JSON
using Printf
using URIs

const SCHEME = "https"

const MININGPOOLHUB_HOST = "ethereum.miningpoolhub.com"
const MININGPOOLHUB_PATH = "/index.php"

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

end # module
