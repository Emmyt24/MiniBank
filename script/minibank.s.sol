//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Script} from "forge-std/Script.sol";
import {MiniBank} from "../src/MiniBank.sol";
contract deployMiniBAnk is Script {
    function run() external returns (MiniBank) {
        vm.startBroadcast();
        MiniBank miniBank = new MiniBank();
        vm.stopBroadcast();

        return miniBank;
    }
}
