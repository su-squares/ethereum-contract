pragma solidity ^0.4.20;

import "./AccessControl.sol";
import "./SuNFT.sol";
//import "./SuOperation.sol";

/// @title A token vending machine
/// @author William Entriken (https://phor.net)
/// @dev See SuMain contract documentation for detail on how contracts interact.
contract SuVending is SuNFT {
    uint256 public constant SALE_PRICE = 500 finney; // 0.5 ether

    /// @notice The price is always 0.5 ether, and you can buy any available Square
    ///  Be sure you are calling this from a regular account (not a smart contract)
    ///  or if you are calling from a smart contract, make sure it can use
    ///  ERC-721 non-fungible tokens
    function purchase(uint256 _nftId)
        external
        payable
        mustBeValidNFT(_nftId)
        mustBeOwnedByThisContract(_nftId)
    {
        require(msg.value == SALE_PRICE);
        _transfer(_nftId, msg.sender);
    }
}
