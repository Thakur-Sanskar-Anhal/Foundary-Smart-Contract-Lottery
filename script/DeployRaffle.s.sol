// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// imports
    import {Script} from "forge-std/Script.sol";
    import {Raffle} from "../src/Raffle.sol";
    import {HelperConfig} from "./HelperConfig.s.sol";
    import {CreateSubscription} from "./Interactions.s.sol";

// contracts
contract DeployRaffle is Script {

// functions
    function run() external returns (Raffle , HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callBackGasLimit,
        address linkToken ) = helperConfig.activeNetworkConfig();

        if (subscriptionId == 0){
            CreateSubscription createSubscription = new CreateSubscription();
            subscriptionId = createSubscription.createSubscription(vrfCoordinator);
        }

        vm.startBroadcast();
            Raffle raffle = new Raffle(
                entranceFee,
                interval,
                vrfCoordinator,
                gasLane,
                subscriptionId,
                callBackGasLimit
            );
        vm.stopBroadcast();
        return (raffle , helperConfig);
    }
}