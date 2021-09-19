import miningprofit.config
import requests
import urllib.parse

def miningpoolhub_get_balance(apikey):
    url_base = 'https://ethereum.miningpoolhub.com/index.php?'
    query_vars = {'page': 'api', 'action': 'getuserbalance', 
        'api_key': apikey}
    query_string = urllib.parse.urlencode(query_vars)
    url = "{}{}".format(url_base, query_string)

    r = requests.get(url)
    return r.json()['getuserbalance']['data']

def miningpoolhub_get_hashrate(apikey):
    url_base = 'https://ethereum.miningpoolhub.com/index.php?'
    query_vars = {'page': 'api', 'action': 'getuserhashrate', 
        'api_key': apikey}
    query_string = urllib.parse.urlencode(query_vars)
    url = "{}{}".format(url_base, query_string)

    r = requests.get(url)
    return r.json()['getuserhashrate']['data']
