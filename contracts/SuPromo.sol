pragma solidity ^0.4.24;

import "./SuNFT.sol";
import "./AccessControl.sol";

/// @title A limited pre-sale and promotional giveaway
/// @author William Entriken (https://phor.net)
contract SuPromo is AccessControl, SuNFT {
    uint256 constant PROMO_CREATION_LIMIT = 5000;

    /// @notice How many promo squares were granted
    uint256 public promoCreatedCount;

    /// @notice BEWARE, this does not use a safe transfer mechanism!
    ///  You must manually check the receiver can accept NFTs
    function grantToken(uint256 _tokenId, address _newOwner)
        external
        onlyOperatingOfficer
        mustBeValidToken(_tokenId)
        mustBeOwnedByThisContract(_tokenId)
    {
        require(promoCreatedCount < PROMO_CREATION_LIMIT);
        promoCreatedCount++;
        _transfer(_tokenId, _newOwner);
    }
}
