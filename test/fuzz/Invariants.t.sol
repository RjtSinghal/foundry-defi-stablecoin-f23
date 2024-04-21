// SPDX-License_Identifier: MIT

// Have our invariant aka properties

// What are our invariants ?

// 1. The total supply of DSC should be less than the total value of collateral
// 2. Getter view functions should never revert <--  evergreen invariant

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {Handler} from "./Handler.t.sol";

contract Invariants is StdInvariant, Test {
    DeployDSC deployer;
    HelperConfig config;
    DSCEngine public dsce;
    DecentralizedStableCoin public dsc;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,, weth, wbtc,) = config.activeNetworkConfig();
        // targetContract(address(dsce));
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
        // only call redeemCollateral, when there is a collateral to redeem.
    }

    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethUsdValue = dsce.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcUsdValue = dsce.getUsdValue(wbtc, totalWbtcDeposited);
        console.log("weth value: ", wethUsdValue);
        console.log("wbtc value: ", wbtcUsdValue);
        console.log("total supply: ", totalSupply);

        assert(wethUsdValue + wbtcUsdValue >= totalSupply);
    }
}
