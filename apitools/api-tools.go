package apitools

import (
	"fmt"
	"github.com/paigeweber13/mining-profit/config"
	"io/ioutil"
	"net/http"
)

// MiningPoolHub
func MPHGetbalance() {
	const MPHUrlEthBalance = "https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserbalance&api_key=%s"

	conf := config.LoadConfig()
	resp, err := http.Get(
		fmt.Sprintf(MPHUrlEthBalance, conf.MiningPoolHub.ApiKey))
	if err != nil {
		fmt.Printf("ERROR: %v", err)
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("ERROR: %v", err)
	}

	fmt.Printf("%s\n", body)
}
