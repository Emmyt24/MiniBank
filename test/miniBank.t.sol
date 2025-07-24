//SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import {Test} from "forge-std/Test.sol";
import {MiniBank} from "../src/MiniBank.sol";
import {deployMiniBank} from "../script/minibank.s.sol";

contract MiniBankTest is Test {
    MiniBank miniBank;

    uint256 public AMOUNT_FUNDED = 10 ether;

    address PAPS = makeAddr("PAPS");

    function setUp() external {
        deployMiniBank deployer = new deployMiniBank();
        miniBank = deployer.run();
        // vm.deal(PAPS, AMOUNT_FUNDED);
    }
    function testRegisteredSuccessfully() public {
        vm.deal(PAPS, AMOUNT_FUNDED);
        vm.prank(PAPS);
        miniBank.register();
        (, bool isRegistered) = miniBank.addressToUser(PAPS);
        assertTrue(isRegistered, "User should be registered");
    }

    function testRevertifBalanceIsLessThanMinimunBalance() public {
        // vm.deal(PAPS,AMOUNT_FUNDED);
        vm.prank(address(miniBank));
        vm.expectRevert();
        miniBank.register();
    }

    function testAllowDepositFromRegiisteredUseronly() public {
        vm.deal(PAPS, AMOUNT_FUNDED);
        vm.prank(PAPS);
        vm.expectRevert();
        miniBank.deposit(AMOUNT_FUNDED);
    }
    function testRevertIfSentValueIsZero() public funded {
        miniBank.register();
        vm.prank(PAPS);
        vm.expectRevert();
        miniBank.deposit(0);
    }
    function testIfBalanceIsLessThanMinimunBalance() public {
        vm.prank(PAPS);
        vm.expectRevert();
        miniBank.register();
    }
    function testUserBalanceUpdateAfterDeposit() public {
        vm.deal(address(miniBank), AMOUNT_FUNDED);
        vm.prank(address(miniBank));
        miniBank.register();
        vm.deal(address(miniBank), AMOUNT_FUNDED);
        vm.prank(address(miniBank));
        miniBank.deposit(2 ether);
        (uint256 balance, ) = miniBank.addressToUser(address(miniBank));
        assertEq(balance, 2 ether);
    }

    modifier funded() {
        vm.deal(PAPS, AMOUNT_FUNDED);
        vm.prank(PAPS);
        _;
    }
}
