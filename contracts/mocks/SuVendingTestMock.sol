pragma solidity ^0.4.24;
import "../SuVending.sol";
import "./SuNFTStealableTestMock.sol";

contract SuVendingTestMock is SuVending, SuNFTStealableTestMock {
    constructor() public {}

    function getSalePrice() external pure returns (uint256) {
        return SALE_PRICE;
    }
}
