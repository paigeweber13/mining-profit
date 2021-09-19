import json

config_file_name = 'config.json'

def load_config():
    with open(config_file_name, 'r') as f:
        config = json.load(f)

    return config
