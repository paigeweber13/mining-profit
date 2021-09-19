import miningprofit.config

if __name__ == '__main__':
    config = miningprofit.config.load_config()
    print(config)
    print(config['miningpoolhub']['apikey'])
