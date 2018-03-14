pragma solidity ^0.4.21;

import "./AccessControl.sol";
import "./SuNFT.sol";
import "./SuOperation.sol";
import "./SuPromo.sol";
import "./SuVending.sol";

/// @title The features that deed owners can use
/// @author William Entriken (https://phor.net)
/// @dev See SuMain contract documentation for detail on how contracts interact.
contract SuMain is AccessControl, SuNFT, SuOperation, SuVending, SuPromo {
    function SuMain() public {
    }
}
 
