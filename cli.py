import miningprofit.config
import miningprofit.apitools

if __name__ == '__main__':
    config = miningprofit.config.load_config()
    miningpoolhub_apikey = config['miningpoolhub']['apikey']

    balance = miningprofit.apitools.miningpoolhub_get_balance(
        miningpoolhub_apikey)
    print(balance)

    hashrate = miningprofit.apitools.miningpoolhub_get_hashrate(
        miningpoolhub_apikey)
    print(hashrate)
