package config

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"strings"
)

type ConfigData struct {
	MiningPoolHub ApiInfo `json: "miningpoolhub"`
}

type ApiInfo struct {
	ApiKey string `json: "apikey"`
}

func LoadConfig() ConfigData {
	const configFileName = "config.json"

	data, err := ioutil.ReadFile(configFileName)
	if err != nil {
		if strings.HasSuffix(err.Error(), "no such file or directory") {
			panic(fmt.Sprintf("Couldn't find config file! Make sure to "+
				"create %s and add your api keys!", configFileName))
		} else {
			panic(err)
		}
	}

	var conf ConfigData
	json.Unmarshal(data, &conf)

	return conf
}
