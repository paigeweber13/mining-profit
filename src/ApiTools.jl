module ApiTools

using HTTP
using JSON
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

end # module
