pragma solidity ^0.4.0;
import "../../contracts/SuPromo.sol";
import "./SuNFTStealableTestMock.sol";

contract SuPromoTestMock is SuPromo, SuNFTStealableTestMock {
    constructor() public {
    }

    function useUpAllGrants() external {
        promoCreatedCount = PROMO_CREATION_LIMIT;
    }
}
