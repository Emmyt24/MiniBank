// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMAL = 8;
    int256 public constant ETH_PRICE = 2000e8;
    struct networkConfig {
        address priceFeed;
    }

    networkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCrreateAnvilEthConfig();
        }
    }

    function getMainnetConfig() public pure returns (networkConfig memory) {
        networkConfig memory mainnetConfig = networkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getSepoliaEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory sepoliaConfig = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCrreateAnvilEthConfig()
        public
        returns (networkConfig memory)
    {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            ETH_PRICE
        );
        vm.stopBroadcast();

        networkConfig memory anvilEthConfig = networkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilEthConfig;
    }
}
