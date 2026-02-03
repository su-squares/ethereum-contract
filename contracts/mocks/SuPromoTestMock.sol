pragma solidity ^0.4.24;
import "../SuPromo.sol";
import "./SuNFTStealableTestMock.sol";

contract SuPromoTestMock is SuPromo, SuNFTStealableTestMock {
    constructor() public {}

    function useUpAllGrants() external {
        promoCreatedCount = PROMO_CREATION_LIMIT;
    }
}
