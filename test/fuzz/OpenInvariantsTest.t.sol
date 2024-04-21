// // SPDX-License_Identifier: MIT

// // Have our invariant aka properties

// // What are our invariants ?

// // 1. The total supply of DSC should be less than the total value of collateral
// // 2. Getter view functions should never revert <--  evergreen invariant

// pragma solidity ^0.8.18;

// import {Test, console} from "forge-std/Test.sol";
// import {StdInvariant} from "forge-std/StdInvariant.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// import {DeployDSC} from "../../script/DeployDSC.s.sol";
// import {HelperConfig} from "../../script/HelperConfig.s.sol";
// import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
// import {DSCEngine} from "../../src/DSCEngine.sol";

// contract OpenInvariantsTest is StdInvariant, Test {
//     DeployDSC deployer;
//     HelperConfig config;
//     DSCEngine dsce;
//     DecentralizedStableCoin dsc;
//     address weth;
//     address wbtc;

//     function setUp() external {
//         deployer = new DeployDSC();
//         (dsc, dsce, config) = deployer.run();
//         (,, weth, wbtc,) = config.activeNetworkConfig();
//         targetContract(address(dsce));
//     }

//     function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
//         uint256 totalSupply = dsc.totalSupply();
//         uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
//         uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

//         uint256 wethUsdValue = dsce.getUsdValue(weth, totalWethDeposited);
//         uint256 wbtcUsdValue = dsce.getUsdValue(wbtc, totalWbtcDeposited);
//         console.log("weth value: ", wethUsdValue);
//         console.log("wbtc value: ", wbtcUsdValue);
//         console.log("total supply: ", totalSupply);

//         assert(wethUsdValue + wbtcUsdValue >= totalSupply);
//     }
// }
