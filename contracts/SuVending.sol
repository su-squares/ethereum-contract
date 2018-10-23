pragma solidity ^0.4.24;

import "./AccessControl.sol";
import "./SuNFT.sol";

/// @title A token vending machine
/// @author William Entriken (https://phor.net)
contract SuVending is SuNFT {
    uint256 constant SALE_PRICE = 500 finney; // 0.5 Ether

    /// @notice The price is always 0.5 Ether, and you can buy any available square
    ///  Be sure you are calling this from a regular account (not a smart contract)
    ///  or if you are calling from a smart contract, make sure it can use
    ///  ERC-721 non-fungible tokens
    function purchase(uint256 _nftId)
        external
        payable
        mustBeValidToken(_nftId)
        mustBeOwnedByThisContract(_nftId)
    {
        require(msg.value == SALE_PRICE);
        _transfer(_nftId, msg.sender);
    }
}
